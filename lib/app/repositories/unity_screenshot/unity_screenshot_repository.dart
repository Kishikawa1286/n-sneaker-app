import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/image_gallery/image_gallery_interface.dart';

final unityScreenshotRepositoryProvider = Provider<UnityScreenshotRepository>(
  (ref) => UnityScreenshotRepository(
    ref.read(imageGalleryInterfaceProvider),
  ),
);

class UnityScreenshotRepository {
  const UnityScreenshotRepository(this._imageGalleryInterface);

  final ImageGalleryInterface _imageGalleryInterface;

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

  Future<void> saveUnityScreenshot(MemoryImage image) async {
    await _imageGalleryInterface.saveImage(bytes: image.bytes);
  }
}
