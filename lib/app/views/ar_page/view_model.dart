import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/collection_product/collection_product_model.dart';
import '../../repositories/collection_product/collection_product_repository.dart';
import '../../repositories/product_glb_file/product_glb_file.dart';
import '../../repositories/product_glb_file/product_glb_file_repository.dart';
import '../../services/account/account_service.dart';
import '../../services/unity_screenshot/unity_screenshot_service.dart';
import '../../services/unity_widget_key/unity_widget_key_service.dart';

final arPageViewModelProvider = AutoDisposeChangeNotifierProvider(
  (ref) => ArPageViewModel(
    ref.watch(accountServiceProvider),
    ref.read(productGlbFileRepositoryProvider),
    ref.read(collectionProductRepositoryProvider),
    ref.watch(unityWidgetKeyServiceProvider),
    ref.watch(unityScreenshotServiceProvider),
  ),
);

class ArPageViewModel extends ViewModelChangeNotifier {
  ArPageViewModel(
    this._accountService,
    this._productGlbFileRepository,
    this._collectionProductRepository,
    this._unityWidgetKeyService,
    this._unityScreenshotService,
  ) {
    _init();
  }

  final AccountService _accountService;
  final ProductGlbFileRepository _productGlbFileRepository;
  final CollectionProductRepository _collectionProductRepository;
  final UnityWidgetKeyService _unityWidgetKeyService;
  final UnityScreenshotService _unityScreenshotService;

  GlobalKey get unityWidgetKey => _unityWidgetKeyService.key;

  late UnityWidgetController _unityWidgetController;
  ProductGlbFileModel? _productGlbFile;
  String _url = '';
  bool _initialized = false;
  bool _noCollectionProductExists = false;

  ProductGlbFileModel? get productGlbFile => _productGlbFile;
  bool get initialized => _initialized;
  bool get noCollectionProductExists => _noCollectionProductExists;

  Future<void> _init() async {
    try {
      final ids = await _productGlbFileRepository.getLastUsedGlbFileId();
      // Shared Preferences に記録がない場合
      if (ids.isEmpty) {
        await _onFirstUse();
        return;
      }
      final fetchedCollectionProduct =
          await _productGlbFileRepository.fetchProductsGlbFileById(
        productId: ids[0],
        productGlbFileId: ids[1],
      );
      // 前回起動時から設定が変わってAR非対応になっていた場合
      if (!fetchedCollectionProduct.availableForAr) {
        await _onFirstUse();
        return;
      }
      await _setGlbFile(fetchedCollectionProduct);
      _initialized = true;
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> _onFirstUse() async {
    final accountId = _accountService.account?.id;
    if (accountId == null) {
      throw Exception('accountId is null.');
    }
    final fetchedCollectionProducts = await _collectionProductRepository
        .fetchCollectionProductsFromFirestore(accountId);
    // コレクションが空の場合
    if (fetchedCollectionProducts.isEmpty) {
      _noCollectionProductExists = true;
      _initialized = true;
      notifyListeners();
      return;
    }
    final collectionProduct = fetchedCollectionProducts.first;
    final fetchedProductGlbFiles = await _productGlbFileRepository
        .fetchProductsGlbFilesForAr(collectionProduct.productId);
    // GLB ファイルがない場合
    if (fetchedProductGlbFiles.isEmpty) {
      throw Exception('no glb file data were fetched.');
    }
    await _setGlbFile(fetchedProductGlbFiles.first);
    _initialized = true;
    notifyListeners();
  }

  Future<void> _setGlbFile(ProductGlbFileModel productGlbFileModel) async {
    _productGlbFile = productGlbFileModel;
    _url = await _productGlbFileRepository.generateGlbFileDownloadUrl(
      productId: productGlbFileModel.productId,
      productGlbFileId: productGlbFileModel.id,
    );
  }

  Future<void> selectCollectionProduct(
    CollectionProductModel collectionProduct,
  ) async {
    try {
      final fetched = await _productGlbFileRepository
          .fetchProductsGlbFilesForAr(collectionProduct.productId);
      if (fetched.isEmpty) {
        return;
      }
      await _setGlbFile(fetched.first);
      if (!collectionProduct.isTrial) {
        await _productGlbFileRepository.setLastUsedGlbFileId(
          productId: fetched.first.productId,
          productGlbFileId: fetched.first.id,
        );
      }
      notifyListeners();
      await _reload();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> onUnityCreated(UnityWidgetController controller) async {
    _unityWidgetController = controller;
    await _enableCamera();
    await _initializeOperationDisplay();
  }

  Future<void> onUnityMessage({
    required dynamic message,
    required void Function() showUnityScreenshotModal,
  }) async {
    if (message == '[[OBJECT_PLACED]]') {
      await _loadObject();
      return;
    }
    if (message == '[[RELOADED]]') {
      await _enableCamera();
      return;
    }
    if (message.toString().contains('[[DOWNLOAD_ASSET_ERROR]]')) {
      print(message);
      return;
    }
    // スクリーンショットのパスがメッセージとして飛んできた場合
    if (message.toString().contains('/ar_screenshots/')) {
      EasyDebounce.debounce(
        'show_unity_screenshot_modal',
        const Duration(milliseconds: 500),
        () {
          _unityScreenshotService.setStates(
            path: message.toString(),
            id: _productGlbFile?.productId ?? '',
          );
          showUnityScreenshotModal();
        },
      );
      return;
    }
    print(message);
  }

  Future<void> _reload() async {
    await _unityWidgetController.postMessage(
      'SceneReloadModel',
      'SceneReload',
      '',
    );
  }

  Future<void> _loadObject() async {
    final f = _productGlbFile;
    if (f == null) {
      return;
    }
    await _unityWidgetController.postMessage(
      'FileLoadModel',
      'Load',
      '{"fileName": "${f.productId}_${f.id}.glb", "url": "$_url"}',
    );
  }

  Future<void> _initializeOperationDisplay() async {
    await _unityWidgetController.postMessage(
      'OperationDisplayModel',
      'Initialize',
      '',
    );
  }

  Future<void> _enableCamera() async {
    await _unityWidgetController.postMessage(
      'TrackingTogglerModel',
      'EnableCamera',
      '',
    );
  }

  Future<void> disableCamera() async {
    await _unityWidgetController.postMessage(
      'TrackingTogglerModel',
      'DisableCamera',
      '',
    );
  }
}
