import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

final imageGalleryInterfaceProvider =
    Provider<ImageGalleryInterface>((ref) => const ImageGalleryInterface());

class ImageGalleryInterface {
  const ImageGalleryInterface();

  Future<void> saveImage({
    required Uint8List bytes,
    String? name,
  }) async {
    await ImageGallerySaver.saveImage(bytes, name: name);
  }
}
