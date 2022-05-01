import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../utils/view_model_change_notifier.dart';
import '../../../../repositories/product/product_model.dart';
import '../../../../repositories/product/product_repository.dart';

final marketPageSeriesProductGridViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<
        MarketPageSeriesProductGridViewModel, String>(
  (ref, series) => MarketPageSeriesProductGridViewModel(
    series,
    ref.read(productRepositoryProvider),
  ),
);

class MarketPageSeriesProductGridViewModel extends ViewModelChangeNotifier {
  MarketPageSeriesProductGridViewModel(
    this._series,
    this._productRepository,
  ) {
    _pagingController.addPageRequestListener(_fetchProducts);
  }

  static const _limit = 16;

  final String _series;
  final ProductRepository _productRepository;

  final PagingController<int, ProductModel> _pagingController =
      PagingController<int, ProductModel>(firstPageKey: 0);

  PagingController<int, ProductModel> get pagingController => _pagingController;

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts(int pageKey) async {
    try {
      final startAfter = pagingController.itemList?.last;
      final fetchedProducts = await _productRepository
          .fetchProductsBySeriesJp(_series, startAfter: startAfter);
      // _pagingControllerのdispose後に操作をするのを回避
      if (disposed) {
        return;
      }
      if (fetchedProducts.length != _limit) {
        _pagingController.appendLastPage(fetchedProducts);
      } else {
        _pagingController.appendPage(fetchedProducts, pageKey + _limit);
      }
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      _pagingController.error = e;
    }
  }
}
