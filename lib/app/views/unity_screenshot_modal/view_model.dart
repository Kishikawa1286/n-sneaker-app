import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/unity_screenshot/unity_screenshot_repository.dart';
import '../../services/unity_screenshot/unity_screenshot_service.dart';

final unityScreenshotModalViewModelProvider = AutoDisposeChangeNotifierProvider(
  (ref) => UnityScreenshotModalViewModel(
    ref.watch(unityScreenshotServiceProvider),
    ref.read(unityScreenshotRepositoryProvider),
  ),
);

class UnityScreenshotModalViewModel extends ViewModelChangeNotifier {
  UnityScreenshotModalViewModel(
    this._unityScreenshotService,
    this._unityScreenshotRepository,
  ) {
    _init();
  }

  final UnityScreenshotService _unityScreenshotService;
  final UnityScreenshotRepository _unityScreenshotRepository;

  MemoryImage? _image;
  bool _postToGallery = true;
  bool _loading = false;

  MemoryImage? get image => _image;
  bool get postToGallery => _postToGallery;
  bool get loading => _loading;

  Future<void> _init() async {
    final path = _unityScreenshotService.screenshotPath;
    // check if set
    if (path.isEmpty) {
      return;
    }
    try {
      _image = await _unityScreenshotRepository.loadUnityScreenshot(path);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  // ignore: avoid_positional_boolean_parameters
  void setPostToGallery(bool? value) {
    if (value == null) {
      return;
    }
    _postToGallery = value;
    notifyListeners();
  }

  void togglePostToGallery() {
    if (_postToGallery) {
      _postToGallery = false;
    } else {
      _postToGallery = true;
    }
    notifyListeners();
  }

  Future<bool> saveImage() async {
    if (_loading) {
      return false;
    }
    final im = _image;
    if (im == null) {
      return false;
    }
    try {
      _loading = true;
      notifyListeners();
      await _unityScreenshotRepository.saveUnityScreenshot(im);
      _loading = false;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      print(e);
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}
