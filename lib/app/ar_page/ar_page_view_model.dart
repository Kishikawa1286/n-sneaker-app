import 'dart:async';

import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../common/view_model_change_notifier.dart';

final ChangeNotifierProvider<ARPageViewModel> arPageViewModelProvider =
    ChangeNotifierProvider((ref) => ARPageViewModel());

class ARPageViewModel extends ViewModelChangeNotifier {
  late UnityWidgetController _unityWidgetController;

  double _intensity = 1;
  double _shadowStrength = 0.8;
  double _theta = 0;
  double _phi = -45;
  bool _capturing = false;
  double _downloadProgress = 0;
  String _productId = '';
  String _productUrl = '';

  double get intensity => _intensity;
  double get shadowStrength => _shadowStrength;
  double get theta => _theta;
  double get phi => _phi;
  bool get capturing => _capturing;
  double get downloadProgress => _downloadProgress;
  bool get downloading => 0 < _downloadProgress && _downloadProgress < 1;

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
    if (message.toString().contains('[[DOWNLOAD_ASSET_DONE]]')) {
      print(message);
      return;
    }
    if (message.toString().contains('{')) {
      print(message);
      return;
    }
    // ダウンロード時
    try {
      _downloadProgress = double.parse(message.toString());
      notifyListeners();
    } on Exception catch (e) {
      print(message);
      print(e);
    }
  }

  void onSelected3DModel({required String id, required String url}) {
    _productId = id;
    _productUrl = url;
  }

  void reloadUnityScene({bool justReload = false}) {
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
      '{"id": "$_productId", "url": "$_productUrl"}',
    );
  }
}
