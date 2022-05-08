import 'package:hooks_riverpod/hooks_riverpod.dart';

final unityScreenshotServiceProvider = Provider<UnityScreenshotService>(
  (ref) => UnityScreenshotService(),
);

class UnityScreenshotService {
  String _screenshotPath = '';
  String _productId = '';

  String get screenshotPath => _screenshotPath;
  String get productId => _productId;

  void setStates({
    required String path,
    required String id,
  }) {
    _screenshotPath = path;
    _productId = id;
  }
}
