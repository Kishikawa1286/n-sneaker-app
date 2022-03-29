import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'revenue_cat_values.dart';

final purchasesInterfaceProvider =
    Provider<PurchasesInterface>((ref) => const PurchasesInterface());

class PurchasesInterface {
  const PurchasesInterface();

  Future<void> setup({required String appUserId}) async {
    if (Platform.isIOS) {
      await Purchases.setup(
        revenueCatIosPublicKey,
        appUserId: appUserId,
      );
    }
    if (Platform.isAndroid) {
      await Purchases.setup(
        revenueCatAndroidPublicKey,
        appUserId: appUserId,
      );
    }
  }

  Future<PurchaserInfo> purchaseProduct(String firebaseProductId) =>
      Purchases.purchaseProduct(
        revenueCatProductIdentifier(firebaseProductId),
        type: PurchaseType.inapp,
      );

  Future<PurchaserInfo> fetchPurchaseInfo() => Purchases.getPurchaserInfo();
}
