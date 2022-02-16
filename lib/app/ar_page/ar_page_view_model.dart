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

  @override
  void dispose() {
    _unityWidgetController.dispose();
    super.dispose();
  }

  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    if (scene?.isLoaded ?? false) {
      Timer(const Duration(milliseconds: 500), notifyListeners);
    }
    notifyListeners();
  }

  void setIntensity(double sliderValue) {
    _intensity = sliderValue;
    _unityWidgetController.postMessage(
      'Directional Light',
      'SetIntensity',
      _intensity.toStringAsFixed(3),
    );
    notifyListeners();
  }

  void setShadowStrength(double sliderValue) {
    _shadowStrength = sliderValue;
    _unityWidgetController.postMessage(
      'Directional Light',
      'SetShadowStrength',
      _shadowStrength.toStringAsFixed(3),
    );
    notifyListeners();
  }

  void setTheta(double sliderValue) {
    _theta = sliderValue;
    _unityWidgetController.postMessage(
      'Directional Light',
      'SetTheta',
      _theta.toStringAsFixed(3),
    );
    notifyListeners();
  }

  void setPhi(double sliderValue) {
    _phi = sliderValue;
    _unityWidgetController.postMessage(
      'Directional Light',
      'SetPhi',
      _phi.toStringAsFixed(3),
    );
    notifyListeners();
  }
}
