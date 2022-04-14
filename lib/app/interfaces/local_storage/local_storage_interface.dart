import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

final localStorageInterfaceProvider =
    Provider<LocalStorageInterface>((ref) => const LocalStorageInterface());

class LocalStorageInterface {
  const LocalStorageInterface();

  Future<Directory> getApplicationDocumentsDirectory() =>
      path_provider.getApplicationDocumentsDirectory();

  Future<Directory> getLibraryDirectory() =>
      path_provider.getLibraryDirectory();

  Future<void> writeBytes({
    required String path,
    required List<int> bytes,
  }) async {
    final file = File(path);
    await file.writeAsBytes(bytes);
  }

  bool fileExists(String path) {
    final file = File(path);
    return file.existsSync();
  }
}
