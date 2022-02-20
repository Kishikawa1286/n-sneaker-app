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
  String _url =
      'https://firebasestorage.googleapis.com/v0/b/n-sneaker-dev.appspot.com/o/test%2FMyName.zip?alt=media&token=bf31730b-bcf8-4d07-af30-aebdc246cd2f';
  bool _capturing = false;

  double get intensity => _intensity;
  double get shadowStrength => _shadowStrength;
  double get theta => _theta;
  double get phi => _phi;
  bool get capturing => _capturing;

  static const String setUrlTriggerMessage = '[[SET_URL]]';

  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
  }

  void onUnityMessage(dynamic message) {
    if (message.toString() == setUrlTriggerMessage) {
      Timer(const Duration(microseconds: 250), _setUrl);
    }
  }

  void reloadUnityScene() {
    _unityWidgetController.postMessage('AR Session', 'Reload', '');
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

  void _setUrl({String? url}) {
    if (url != null) {
      _url = url;
    }
    _unityWidgetController.postMessage(
      'Target Sneaker',
      'SetDownloadURL',
      _url,
    );
  }
}
