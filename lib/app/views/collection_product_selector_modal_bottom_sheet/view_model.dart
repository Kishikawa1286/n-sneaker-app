import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../utils/view_model_change_notifier.dart';
import '../../repositories/collection_product/collection_product_model.dart';
import '../../repositories/collection_product/collection_product_repository.dart';
import '../../services/account/account_service.dart';

final collectionProductSelectorModalBottomSheetViewModelProvider =
    AutoDisposeChangeNotifierProvider<
        CollectionProductSelectorModalBottomSheetViewModel>(
  (ref) => CollectionProductSelectorModalBottomSheetViewModel(
    ref.read(collectionProductRepositoryProvider),
    ref.watch(accountServiceProvider),
  ),
);

class CollectionProductSelectorModalBottomSheetViewModel
    extends ViewModelChangeNotifier {
  CollectionProductSelectorModalBottomSheetViewModel(
    this._collectionProductRepository,
    this._accountService,
  ) {
    _pagingController.addPageRequestListener(_fetchProducts);
  }

  static const _limit = 16;

  final CollectionProductRepository _collectionProductRepository;
  final AccountService _accountService;

  final PagingController<int, CollectionProductModel> _pagingController =
      PagingController<int, CollectionProductModel>(firstPageKey: 0);

  PagingController<int, CollectionProductModel> get pagingController =>
      _pagingController;

  Future<void> _fetchProducts(int pageKey) async {
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
      if (fetchedCollectionProducts.length != _limit) {
        _pagingController.appendLastPage(fetchedCollectionProducts);
      } else {
        _pagingController.appendPage(
          fetchedCollectionProducts,
          pageKey + _limit,
        );
      }
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      _pagingController.error = e;
    }
  }
}
