import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/adapty/adapty_repository.dart';
import '../../repositories/collection_product/collection_product_repository.dart';
import '../../repositories/product/product_model.dart';
import '../../repositories/product/product_repository.dart';
import '../../services/account/account_service.dart';
import '../../services/adapty/adapty_service.dart';

final marketDetailPageViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<MarketDetailPageViewModel, String>(
  (ref, id) => MarketDetailPageViewModel(
    id,
    ref.watch(accountServiceProvider),
    ref.read(productRepositoryProvider),
    ref.read(collectionProductRepositoryProvider),
    ref.read(adaptyServiceProvider),
    ref.read(adaptyRepositoryProvider),
  ),
);

class MarketDetailPageViewModel extends ViewModelChangeNotifier {
  MarketDetailPageViewModel(
    this._productId,
    this._accountService,
    this._productRepository,
    this._collectionProductRepository,
    this._adaptyService,
    this._adaptyRepository,
  ) {
    _fetchProduct();
  }

  final String _productId;
  final AccountService _accountService;
  final ProductRepository _productRepository;
  final CollectionProductRepository _collectionProductRepository;
  final AdaptyService _adaptyService;
  final AdaptyRepository _adaptyRepository;

  final CarouselController _carouselController = CarouselController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductModel? _product;
  bool? _purchased;
  int _carouselIndex = 0;
  bool _purchaseInProgress = false;

  ProductModel? get product => _product;
  bool? get purchased => _purchased;
  CarouselController get carouselController => _carouselController;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  int get carouselIndex => _carouselIndex;
  bool get purchaseInProgress => _purchaseInProgress;

  Future<void> _fetchProduct() async {
    try {
      _product = await _productRepository.fetchProductById(_productId);
      final accout = _accountService.account;
      if (accout == null) {
        throw Exception('not authenticated.');
      }
      _purchased = await _collectionProductRepository.checkIfPurchased(
        accountId: accout.id,
        productId: _productId,
      );
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  void setCarouselIndex(int index) {
    _carouselIndex = index;
    notifyListeners();
  }

  Future<String> purchase() async {
    if (_purchaseInProgress) {
      return '';
    }
    _purchaseInProgress = true;
    notifyListeners();
    try {
      final result = await _adaptyService.makePurchase(_productId);
      if (result == null) {
        _purchaseInProgress = false;
        notifyListeners();
        throw Exception('purchase failed.');
      }
      _purchased = true;
    } on Exception catch (e) {
      print(e);
      _purchaseInProgress = false;
      notifyListeners();
      return '購入がキャンセルされました。';
    }
    _purchaseInProgress = false;
    notifyListeners();
    return '${_product?.titleJp} を購入しました。';
  }

  Future<String> revertPurchase() async {
    if (_purchaseInProgress) {
      return '';
    }
    _purchaseInProgress = true;
    notifyListeners();
    try {
      final purchaserInfo = await _adaptyRepository.fetchPurchaserInfo();
      if (purchaserInfo.accessLevels[_productId] == null) {
        throw Exception('no adapty access level exists.');
      }
    } on Exception catch (e) {
      print(e);
      _purchaseInProgress = false;
      notifyListeners();
      return '購入の情報がないため、決済を復元できませんでした。';
    }
    try {
      await _collectionProductRepository.addCollectionProduct(
        productId: _productId,
      );
      _purchased = true;
    } on Exception catch (e) {
      print(e);
      _purchaseInProgress = false;
      notifyListeners();
      return '購入の情報を確認できましたが、決済の復元中にエラーが発生しました。';
    }
    _purchaseInProgress = false;
    notifyListeners();
    return '決済を復元しました。';
  }
}
