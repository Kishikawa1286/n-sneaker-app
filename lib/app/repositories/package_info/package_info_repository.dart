import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/package_info/package_info_interface.dart';

final packageInfoRepositoryProvider = Provider<PackageInfoRepository>(
  (ref) => PackageInfoRepository(ref.read(packageInfoInterfaceProvider)),
);

class PackageInfoRepository {
  const PackageInfoRepository(this._packageInfoInterface);

  final PackageInfoInterface _packageInfoInterface;

  Future<String> getVersion() => _packageInfoInterface.getVersion();

  Future<String> getBuildNumber() => _packageInfoInterface.getBuildNumber();
}
