import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/gallery_post/gallery_post_repository.dart';
import '../../repositories/unity_screenshot/unity_screenshot_repository.dart';
import '../../services/account/account_service.dart';
import '../../services/unity_screenshot/unity_screenshot_service.dart';

final unityScreenshotModalViewModelProvider = AutoDisposeChangeNotifierProvider(
  (ref) => UnityScreenshotModalViewModel(
    ref.watch(unityScreenshotServiceProvider),
    ref.watch(accountServiceProvider),
    ref.read(unityScreenshotRepositoryProvider),
    ref.read(galleryPostRepositoryProvider),
  ),
);

class UnityScreenshotModalViewModel extends ViewModelChangeNotifier {
  UnityScreenshotModalViewModel(
    this._unityScreenshotService,
    this._accountService,
    this._unityScreenshotRepository,
    this._galleryPostRepository,
  ) {
    _init();
  }

  final UnityScreenshotService _unityScreenshotService;
  final AccountService _accountService;
  final UnityScreenshotRepository _unityScreenshotRepository;
  final GalleryPostRepository _galleryPostRepository;

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

  Future<bool> saveImage({bool skipCheckingLoadingState = false}) async {
    if (_loading && !skipCheckingLoadingState) {
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

  Future<bool> saveAndUploadToGallery() async {
    if (_loading) {
      return false;
    }
    final im = _image;
    if (im == null) {
      return false;
    }
    final account = _accountService.account;
    if (account == null) {
      return false;
    }
    final productId = _unityScreenshotService.productId;
    if (productId.isEmpty) {
      return false;
    }
    try {
      _loading = true;
      notifyListeners();

      await saveImage(skipCheckingLoadingState: true);
      await _galleryPostRepository.addGalleryPost(
        accountId: account.id,
        productId: productId,
        image: im,
      );

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
