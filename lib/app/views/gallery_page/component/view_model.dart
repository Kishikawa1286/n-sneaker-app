import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/view_model_change_notifier.dart';
import '../../../repositories/product/product_model.dart';
import '../../../repositories/product/product_repository.dart';

final galleryImageViewerViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<GalleryImageViewerViewModel,
        String>(
  (ref, productId) => GalleryImageViewerViewModel(
    productId,
    ref.read(productRepositoryProvider),
  ),
);

class GalleryImageViewerViewModel extends ViewModelChangeNotifier {
  GalleryImageViewerViewModel(
    this._productId,
    this._productRepository,
  ) {
    _init();
  }

  final String _productId;

  final ProductRepository _productRepository;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  ProductModel? _product;

  ProductModel? get product => _product;

  Future<void> _init() async {
    try {
      _product = await _productRepository.fetchProductById(_productId);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
}
