import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../interfaces/revenuecat/revenuecat_interface.dart';

final revenuecatRepositoryProvider = Provider<RevenuecatRepository>(
  (ref) => RevenuecatRepository(ref.read(revenuecatInterfaceProvider)),
);

class RevenuecatRepository {
  const RevenuecatRepository(this._revenuecatInterface);

  final RevenuecatInterface _revenuecatInterface;

  Future<LogInResult> signIn({required String accountId}) =>
      _revenuecatInterface.signIn(accountId: accountId);

  Future<PurchaserInfo> signOut() => _revenuecatInterface.signOut();

  Future<PurchaserInfo> fetchPurchaserInfo() =>
      _revenuecatInterface.fetchPurchaserInfo();

  Future<PurchaserInfo> purchase({required String revenuecatPackageId}) async {
    final package = await _fetchConsumablePackage(revenuecatPackageId);
    return _revenuecatInterface.purchasePackage(package);
  }

  Future<Package> _fetchConsumablePackage(String packageId) async {
    final offerings = await _revenuecatInterface.fetchOfferings();
    // consumable offeringにすべてのpackageを入れている
    final offering = offerings.all['consumable'];
    if (offering == null) {
      throw Exception('offering "consumable" is null.');
    }
    final package = offering.getPackage(packageId);
    if (package == null) {
      throw Exception('package "$packageId" does not exist.');
    }
    return package;
  }
}
