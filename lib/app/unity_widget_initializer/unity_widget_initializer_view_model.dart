import 'dart:async';

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

  bool _initialized = false;

  bool get initialized => _initialized;

  void _initializeUnity() {
    Timer(const Duration(milliseconds: 1200), () {
      _initialized = true;
      notifyListeners();
    });
  }
}
