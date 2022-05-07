import 'package:hooks_riverpod/hooks_riverpod.dart';

final unityScreenshotServiceProvider = Provider<UnityScreenshotService>(
  (ref) => UnityScreenshotService(),
);

class UnityScreenshotService {
  String _screenshotPath = '';

  String get screenshotPath => _screenshotPath;

  void setScreenshotPath(String path) {
    _screenshotPath = path;
  }
}
