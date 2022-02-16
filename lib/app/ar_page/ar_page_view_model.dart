import 'dart:async';

import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../common/view_model_change_notifier.dart';

final AutoDisposeChangeNotifierProvider<ARPageViewModel>
    arPageViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => ARPageViewModel(),
);

class ARPageViewModel extends ViewModelChangeNotifier {
  late UnityWidgetController _unityWidgetController;

  double _intensity = 1;
  double _shadowStrength = 0.8;
  double _theta = 0;
  double _phi = 45;

  double get intensity => _intensity;
  double get shadowStrength => _shadowStrength;
  double get theta => _theta;
  double get phi => _phi;

  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
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
}
