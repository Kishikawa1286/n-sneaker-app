import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../interfaces/purchases/purchases_interface.dart';

final purchasesRepositoryProvider = Provider<PurchasesRepository>(
  (ref) => PurchasesRepository(ref.read(purchasesInterfaceProvider)),
);

class PurchasesRepository {
  const PurchasesRepository(this._purchasesInterface);

  final PurchasesInterface _purchasesInterface;

  Future<void> setup({required String appUserId}) =>
      _purchasesInterface.setup(appUserId: appUserId);

  Future<PurchaserInfo> purchaseProduct(String firebaseProductId) =>
      _purchasesInterface.purchaseProduct(firebaseProductId);

  Future<PurchaserInfo> fetchPurchaseInfo() =>
      _purchasesInterface.fetchPurchaseInfo();
}
