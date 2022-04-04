import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../utils/view_model_change_notifier.dart';
import '../../../utils/environment_variables.dart';
import '../../repositories/collection_page_state/collection_page_state_repository.dart';
import '../../repositories/collection_product/collection_product_model.dart';
import '../../repositories/collection_product/collection_product_repository.dart';
import '../../services/account/account_service.dart';

final collectionPageProductGridViewModelProvider =
    AutoDisposeChangeNotifierProvider<CollectionPageProductGridViewModel>(
  (ref) => CollectionPageProductGridViewModel(
    ref.read(collectionProductRepositoryProvider),
    ref.read(collectionPageStateRepositoryProvider),
    ref.watch(accountServiceProvider),
  ),
);

class CollectionPageProductGridViewModel extends ViewModelChangeNotifier {
  CollectionPageProductGridViewModel(
    this._collectionProductRepository,
    this._collectionPageStateRepository,
    this._accountService,
  ) {
    _init();
  }

  static const _limit = 16;

  final CollectionProductRepository _collectionProductRepository;
  final CollectionPageStateRepository _collectionPageStateRepository;
  final AccountService _accountService;

  final PagingController<int, CollectionProductModel> _pagingController =
      PagingController<int, CollectionProductModel>(firstPageKey: 0);
  bool _noCollectionProductExists = false;
  int? _backgroundImageIndex;

  PagingController<int, CollectionProductModel> get pagingController =>
      _pagingController;
  bool get noCollectionProductExists => _noCollectionProductExists;
  String? get backgroundImagePath {
    final index = _backgroundImageIndex;
    if (index == null) {
      return null;
    }
    return collectionPageBackgroundImagePaths[_backgroundImageIndex!];
  }

  Future<void> _init() async {
    _pagingController.addPageRequestListener(_fetchProducts);
    _backgroundImageIndex = await _collectionPageStateRepository
        .getLastSetCollectionPageBackgroundImageIndex();
  }

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
      if (pageKey == 0 && fetchedCollectionProducts.isEmpty) {
        _noCollectionProductExists = true;
        notifyListeners();
        return;
      }
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

  void setBackgroundImageIndex(int index) {
    _backgroundImageIndex = index;
    notifyListeners();
    _collectionPageStateRepository
        .setLastSetCollectionPageBackgroundImageIndex(index);
  }
}
