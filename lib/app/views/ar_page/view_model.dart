import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/collection_product/collection_product_repository.dart';
import '../../repositories/product_glb_file/product_glb_file.dart';
import '../../repositories/product_glb_file/product_glb_file_repository.dart';
import '../../services/account/account_service.dart';
import '../../services/unity_widget_key/unity_widget_key_service.dart';

final arPageViewModelProvider = AutoDisposeChangeNotifierProvider(
  (ref) => ArPageViewModel(
    ref.watch(accountServiceProvider),
    ref.read(productGlbFileRepositoryProvider),
    ref.read(collectionProductRepositoryProvider),
    ref.watch(unityWidgetKeyServiceProvider),
  ),
);

class ArPageViewModel extends ViewModelChangeNotifier {
  ArPageViewModel(
    this._accountService,
    this._productGlbFileRepository,
    this._collectionProductRepository,
    this._unityWidgetKeyService,
  ) {
    _init();
  }

  final AccountService _accountService;
  final ProductGlbFileRepository _productGlbFileRepository;
  final CollectionProductRepository _collectionProductRepository;
  final UnityWidgetKeyService _unityWidgetKeyService;

  GlobalKey get unityWidgetKey => _unityWidgetKeyService.key;

  late UnityWidgetController _unityWidgetController;
  ProductGlbFileModel? _productGlbFile;
  String _url = '';
  bool _initialized = false;

  ProductGlbFileModel? get productGlbFile => _productGlbFile;
  bool get initialized => _initialized;

  Future<void> _init() async {
    try {
      final accountId = _accountService.account?.id;
      if (accountId == null) {
        throw Exception('accountId is null.');
      }
      final ids = await _productGlbFileRepository.getLastUsedGlbFileId();
      // Shared Preferences に記録がない場合
      if (ids.isEmpty) {
        final fetchedCollectionProducts = await _collectionProductRepository
            .fetchCollectionProductsFromFirestore(accountId);
        if (fetchedCollectionProducts.isEmpty) {
          throw Exception('no collection product was fetched.');
        }
        final collectionProduct = fetchedCollectionProducts.first;
        final fetchedProductGlbFiles = await _productGlbFileRepository
            .fetchProductsGlbFilesForAr(collectionProduct.productId);
        if (fetchedProductGlbFiles.isEmpty) {
          throw Exception('no glb file data were fetched.');
        }
        await selectGlbFile(fetchedProductGlbFiles.first);
        _initialized = true;
        notifyListeners();
        return;
      }
      _productGlbFile =
          await _productGlbFileRepository.fetchProductsGlbFileById(
        productId: ids[0],
        productGlbFileId: ids[1],
      );
      _initialized = true;
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> selectGlbFile(ProductGlbFileModel selected) async {
    _productGlbFile = selected;
    _url = await _productGlbFileRepository.generateGlbFileDownloadUrl(
      productId: selected.productId,
      productGlbFileId: selected.id,
    );
    notifyListeners();
    await _productGlbFileRepository.setLastUsedGlbFileId(
      productId: selected.productId,
      productGlbFileId: selected.id,
    );
  }

  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
  }

  void onUnityMessage(dynamic message) {
    if (message == '[[OBJECT_PLACED]]') {
      _loadObject();
      return;
    }
    if (message.toString().contains('[[DOWNLOAD_ASSET_ERROR]]')) {
      print(message);
      return;
    }
    // ダウンロード時
    /*
    try {
      final json = jsonDecode(message.toString()) as Map<dynamic, dynamic>;
      if (json['name'] == 'load') {
        _loadProgress = double.parse(json['value'].toString());
        notifyListeners();
        return;
      }
      if (json['name'] == 'download') {
        _downloadProgress = double.parse(json['value'].toString());
        notifyListeners();
        return;
      }
    } on Exception catch (e) {
      print(message);
      print(e);
    }
    */
  }

  void _loadObject() {
    final f = _productGlbFile;
    if (f == null) {
      return;
    }
    _unityWidgetController.postMessage(
      'Target Sneaker',
      'LoadModel',
      '{"id": "${f.productId}_${f.id}", "url": "$_url"}',
    );
  }
}
