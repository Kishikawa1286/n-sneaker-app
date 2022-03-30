import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoInterfaceProvider =
    Provider<PackageInfoInterface>((ref) => const PackageInfoInterface());

class PackageInfoInterface {
  const PackageInfoInterface();

  Future<String> getVersion() async =>
      (await PackageInfo.fromPlatform()).version;

  Future<String> getBuildNumber() async =>
      (await PackageInfo.fromPlatform()).buildNumber;
}
