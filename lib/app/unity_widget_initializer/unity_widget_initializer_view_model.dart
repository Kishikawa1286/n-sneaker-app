import 'dart:async';
import 'dart:io';

import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../common/view_model_change_notifier.dart';

final ChangeNotifierProvider<UnityWidgetInitializerViewModel>
    unityWidgetInitializerViewModelProvider = ChangeNotifierProvider(
  (ref) => UnityWidgetInitializerViewModel(),
);

class UnityWidgetInitializerViewModel extends ViewModelChangeNotifier {
  UnityWidgetInitializerViewModel() {
    _initializeUnity();
  }

  late UnityWidgetController _unityWidgetController;
  bool _initialized = false;

  UnityWidgetController get unityWidgetController => _unityWidgetController;
  bool get initialized => _initialized || Platform.isAndroid;

  void _initializeUnity() {
    Timer(const Duration(milliseconds: 5000), () {
      _initialized = true;
      notifyListeners();
    });
  }

  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
  }
}
