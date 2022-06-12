import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/random_string.dart';
import '../../interfaces/image_gallery/image_gallery_interface.dart';
import '../../interfaces/local_storage/local_storage_interface.dart';

final unityScreenshotRepositoryProvider = Provider<UnityScreenshotRepository>(
  (ref) => UnityScreenshotRepository(
    ref.read(imageGalleryInterfaceProvider),
    ref.read(localStorageInterfaceProvider),
  ),
);

class UnityScreenshotRepository {
  const UnityScreenshotRepository(
    this._imageGalleryInterface,
    this._localStorageInterface,
  );

  final ImageGalleryInterface _imageGalleryInterface;
  final LocalStorageInterface _localStorageInterface;

  Future<MemoryImage?> loadUnityScreenshot(String path) async {
    try {
      final file = File(path);
      if (!file.existsSync()) {
        print('file does not exist.');
        return null;
      }
      final bytes = await file.readAsBytes();
      final image = MemoryImage(bytes);
      return image;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> saveUnityScreenshotToGallery(MemoryImage image) async {
    await _imageGalleryInterface.saveImage(bytes: image.bytes);
  }

  Future<File> saveUnityScreenshotToTemporaryDirectory(
    MemoryImage image,
  ) async {
    final randomStr = randomString();
    final tempDir = await _localStorageInterface.getTemporaryDirectory();
    return _localStorageInterface.writeBytes(
      path: '${tempDir.path}/$randomStr.png',
      bytes: image.bytes,
    );
  }
}
