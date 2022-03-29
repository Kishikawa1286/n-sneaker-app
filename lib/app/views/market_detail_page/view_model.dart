import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/collection_product/collection_product_repository.dart';
import '../../repositories/product/product_model.dart';
import '../../repositories/product/product_repository.dart';
import '../../repositories/purchases/purchases_repository.dart';
import '../../services/account/account_service.dart';

final marketDetailPageViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<MarketDetailPageViewModel, String>(
  (ref, id) => MarketDetailPageViewModel(
    id,
    ref.watch(accountServiceProvider),
    ref.read(productRepositoryProvider),
    ref.read(collectionProductRepositoryProvider),
    ref.read(purchasesRepositoryProvider),
  ),
);

class MarketDetailPageViewModel extends ViewModelChangeNotifier {
  MarketDetailPageViewModel(
    this._productId,
    this._accountService,
    this._productRepository,
    this._collectionProductRepository,
    this._purchasesRepository,
  ) {
    _fetchProduct();
  }

  final String _productId;
  final AccountService _accountService;
  final ProductRepository _productRepository;
  final CollectionProductRepository _collectionProductRepository;
  final PurchasesRepository _purchasesRepository;

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
      final info = await _purchasesRepository.purchaseProduct(_productId);
      // 決済できているかを一度クライアント側で確認
      if (info.entitlements.active.keys.contains(_productId)) {
        await _collectionProductRepository.addCollectionProduct(
          productId: _productId,
        );
        _purchased = true;
      }
    } on Exception catch (e) {
      print(e);
      return '購入に失敗しました。決済を行った場合は決済状態の復元を試みてください。';
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
      final info = await _purchasesRepository.fetchPurchaseInfo();
      if (info.entitlements.active.keys.contains(_productId)) {
        await _collectionProductRepository.addCollectionProduct(
          productId: _productId,
        );
        _purchased = true;
      }
    } on Exception catch (e) {
      print(e);
      return '購入の情報がないため、決済を復元できませんでした。';
    }
    _purchaseInProgress = false;
    notifyListeners();
    return '決済を復元しました。';
  }
}
