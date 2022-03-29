import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/view_model_change_notifier.dart';
import '../services/unity_widget_key/unity_widget_key_service.dart';

class _ARPageViewModelConstructorParams {
  const _ARPageViewModelConstructorParams({
    required this.productId,
    required this.productGlbFileId,
    required this.productUrl,
  });

  factory _ARPageViewModelConstructorParams.fromJson(String jsonStr) {
    final params = jsonDecode(jsonStr) as Map<String, dynamic>;
    return _ARPageViewModelConstructorParams(
      productId: params['product_id'] as String? ?? '',
      productGlbFileId: params['product_glb_file_id'] as String? ?? '',
      productUrl: params['url'] as String? ?? '',
    );
  }

  final String productId;
  final String productGlbFileId;
  final String productUrl;
}

final arPageViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<_ARPageViewModel, String>(
        (ref, paramsAsJson) {
  final params = _ARPageViewModelConstructorParams.fromJson(paramsAsJson);
  return _ARPageViewModel(
    params.productId,
    params.productGlbFileId,
    params.productUrl,
    ref.watch(unityWidgetKeyServiceProvider),
  );
});

class _ARPageViewModel extends ViewModelChangeNotifier {
  _ARPageViewModel(
    this._productId,
    this._productGlbFileId,
    this._productUrl,
    this._unityWidgetKeyService,
  );

  final String _productId;
  final String _productGlbFileId;
  final String _productUrl;
  final UnityWidgetKeyService _unityWidgetKeyService;

  GlobalKey get unityWidgetKey => _unityWidgetKeyService.key;

  late UnityWidgetController _unityWidgetController;

  double _intensity = 1;
  double _shadowStrength = 0.8;
  double _theta = 0;
  double _phi = -45;
  bool _capturing = false;
  double _downloadProgress = 0;
  double _loadProgress = 0;

  double get intensity => _intensity;
  double get shadowStrength => _shadowStrength;
  double get theta => _theta;
  double get phi => _phi;
  bool get capturing => _capturing;
  double get downloadProgress => _downloadProgress;
  bool get downloading => 0 < _downloadProgress && _downloadProgress < 1;
  double get loadProgress => _loadProgress;
  bool get loading => 0 < _loadProgress && _loadProgress < 1;

  Future<void> onPop() async {
    if (Platform.isIOS) {
      reloadUnityScene(justReload: true);
    } else {
      await _unityWidgetController.unload();
    }
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
  }

  void reloadUnityScene({bool justReload = false}) {
    _downloadProgress = 0;
    _loadProgress = 0;
    _unityWidgetController.postMessage('AR Session', 'Reload', '');
    if (justReload) {
      return;
    }
    // wait for loading unity session
    Timer(const Duration(milliseconds: 500), () {
      _setIntensity();
      _setShadowStrength();
      _setTheta();
      _setPhi();
    });
    notifyListeners();
  }

  Future<void> captureAndShareScreenshot() async {
    _capturing = true;
    notifyListeners();
    // wait for rebuild
    Timer(const Duration(milliseconds: 200), () async {
      final path = await NativeScreenshot.takeScreenshot();
      _capturing = false;
      notifyListeners();
      if (path != null) {
        await Share.shareFiles([path], text: '');
      }
    });
  }

  void onChangedIntensitySlider(double sliderValue) {
    _intensity = sliderValue;
    _setIntensity();
    notifyListeners();
  }

  void onChangedShadowStrengthSlider(double sliderValue) {
    _shadowStrength = sliderValue;
    _setShadowStrength();
    notifyListeners();
  }

  void onChangedThetaSlider(double sliderValue) {
    _theta = sliderValue;
    _setTheta();
    notifyListeners();
  }

  void onChangedPhiSlider(double sliderValue) {
    _phi = sliderValue;
    _setPhi();
    notifyListeners();
  }

  void _setIntensity() {
    _unityWidgetController.postMessage(
      'Directional Light',
      'SetIntensity',
      _intensity.toStringAsFixed(3),
    );
  }

  void _setShadowStrength() {
    _unityWidgetController.postMessage(
      'Directional Light',
      'SetShadowStrength',
      _shadowStrength.toStringAsFixed(3),
    );
  }

  void _setTheta() {
    _unityWidgetController.postMessage(
      'Directional Light',
      'SetTheta',
      _theta.toStringAsFixed(3),
    );
  }

  void _setPhi() {
    _unityWidgetController.postMessage(
      'Directional Light',
      'SetPhi',
      _phi.toStringAsFixed(3),
    );
  }

  void _loadObject() {
    _unityWidgetController.postMessage(
      'Target Sneaker',
      'LoadModel',
      '{"id": "${_productId}_$_productGlbFileId", "url": "$_productUrl"}',
    );
  }
}
