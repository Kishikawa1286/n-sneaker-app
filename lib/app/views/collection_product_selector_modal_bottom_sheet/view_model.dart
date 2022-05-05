import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../utils/view_model_change_notifier.dart';
import '../../repositories/collection_product/collection_product_model.dart';
import '../../repositories/collection_product/collection_product_repository.dart';
import '../../repositories/product/product_repository.dart';
import '../../services/account/account_service.dart';

final collectionProductSelectorModalBottomSheetViewModelProvider =
    AutoDisposeChangeNotifierProvider<
        CollectionProductSelectorModalBottomSheetViewModel>(
  (ref) => CollectionProductSelectorModalBottomSheetViewModel(
    ref.read(productRepositoryProvider),
    ref.read(collectionProductRepositoryProvider),
    ref.watch(accountServiceProvider),
  ),
);

class CollectionProductSelectorModalBottomSheetViewModel
    extends ViewModelChangeNotifier {
  CollectionProductSelectorModalBottomSheetViewModel(
    this._productRepository,
    this._collectionProductRepository,
    this._accountService,
  ) {
    _pagingController.addPageRequestListener(_fetchProducts);
  }

  static const _limit = 16;
  static const _trialLimit = 32;

  bool _loading = false;

  final ProductRepository _productRepository;
  final CollectionProductRepository _collectionProductRepository;
  final AccountService _accountService;

  final PagingController<int, CollectionProductModel> _pagingController =
      PagingController<int, CollectionProductModel>(firstPageKey: 0);

  PagingController<int, CollectionProductModel> get pagingController =>
      _pagingController;

  Future<void> _fetchProducts(int pageKey) async {
    if (_loading) {
      return;
    }
    _loading = true;
    try {
      final accountId = _accountService.account?.id;
      if (accountId == null) {
        return;
      }
      final startAfter = pagingController.itemList?.last;
      final fetchedCollectionProducts = await _collectionProductRepository
          .fetchCollectionProductsFromFirestore(
        accountId,
        startAfter: startAfter,
      );

      if (fetchedCollectionProducts.length == _limit) {
        _pagingController.appendPage(
          fetchedCollectionProducts,
          pageKey + _limit,
        );
        notifyListeners();
        _loading = false;
        return;
      }

      if (_accountService.isTrialActive()) {
        _pagingController.appendPage(
          fetchedCollectionProducts,
          pageKey + fetchedCollectionProducts.length,
        );
        final trialProducts = await _productRepository
            .fetchProductsAvailableInTrial(limit: _trialLimit);
        _pagingController.appendLastPage(
          _collectionProductRepository
              .convertProductsToCollectionProducts(trialProducts),
        );
        notifyListeners();
        _loading = false;
        return;
      }

      _pagingController.appendLastPage(fetchedCollectionProducts);
      notifyListeners();
      _loading = false;
    } on Exception catch (e) {
      print(e);
      _pagingController.error = e;
    }
  }
}
