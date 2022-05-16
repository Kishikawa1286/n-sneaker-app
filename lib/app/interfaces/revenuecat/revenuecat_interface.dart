import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final revenuecatInterfaceProvider =
    Provider<RevenuecatInterface>((ref) => const RevenuecatInterface());

class RevenuecatInterface {
  const RevenuecatInterface();

  Future<LogInResult> signIn({required String accountId}) =>
      Purchases.logIn(accountId);

  Future<PurchaserInfo> signOut() => Purchases.logOut();

  Future<PurchaserInfo> fetchPurchaserInfo() => Purchases.getPurchaserInfo();

  Future<Offerings> fetchOfferings() => Purchases.getOfferings();

  Future<PurchaserInfo> purchasePackage(Package package) =>
      Purchases.purchasePackage(package);
}
