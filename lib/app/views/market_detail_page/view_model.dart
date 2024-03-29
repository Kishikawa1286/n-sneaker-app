import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/object_wrappers.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/collection_product/collection_product_repository.dart';
import '../../repositories/product/product_model.dart';
import '../../repositories/product/product_repository.dart';
import '../../repositories/revenuecat/revenuecat_repository.dart';
import '../../services/account/account_service.dart';

final marketDetailPageViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<MarketDetailPageViewModel, String>(
  (ref, id) => MarketDetailPageViewModel(
    id,
    ref.watch(accountServiceProvider),
    ref.read(productRepositoryProvider),
    ref.read(collectionProductRepositoryProvider),
    ref.read(revenuecatRepositoryProvider),
  ),
);

class MarketDetailPageViewModel extends ViewModelChangeNotifier {
  MarketDetailPageViewModel(
    this._productId,
    this._accountService,
    this._productRepository,
    this._collectionProductRepository,
    this._revenuecatRepository,
  ) {
    _fetchProduct();
  }

  final String _productId;
  final AccountService _accountService;
  final ProductRepository _productRepository;
  final CollectionProductRepository _collectionProductRepository;
  final RevenuecatRepository _revenuecatRepository;

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
    final p = _product;
    // Lintの警告回避のためにadaptyPaywallIdもnullチェック
    if ((_purchased ?? true) || _purchaseInProgress || p == null) {
      return '';
    }
    final revenuecatPackageId = p.revenuecatPackageId;
    if (revenuecatPackageId.isEmpty) {
      return 'この商品は現在購入できません。';
    }
    _purchaseInProgress = true;
    notifyListeners();
    try {
      final result = await _revenuecatRepository.purchase(
        revenuecatPackageId: revenuecatPackageId,
      );
      try {
        await _collectionProductRepository.addCollectionProductOnMakingPurchase(
          product: p,
          transaction: result.nonSubscriptionTransactions.last,
        );
        _purchased = true;
      } on Exception catch (e) {
        print(e);
        _purchaseInProgress = false;
        notifyListeners();
        return '決済を完了しましたが、エラーが発生しました。購入の復元を行ってください。';
      }
    } on PurchasesErrorCode catch (e) {
      print(e);
      _purchaseInProgress = false;
      notifyListeners();
      return '決済に失敗しました。';
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

  Future<String> restore() async {
    // Lintの警告回避のためにadaptyPaywallIdもnullチェック
    if ((_purchased ?? true) || _purchaseInProgress) {
      return '';
    }
    _purchaseInProgress = true;
    notifyListeners();
    try {
      await _collectionProductRepository
          .addCollectionProductOnRestoringPurchase(_productId);
    } on Exception catch (e) {
      print(e);
      _purchaseInProgress = false;
      notifyListeners();
      return '購入情報がありません。購入している場合はお問い合わせください。';
    }
    _purchased = true;
    _purchaseInProgress = false;
    notifyListeners();
    return '${_product?.titleJp} の購入状態を復元しました。';
  }
}
