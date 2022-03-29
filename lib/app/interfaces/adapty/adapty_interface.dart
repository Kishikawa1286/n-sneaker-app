import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adapty_flutter/models/adapty_product.dart';
import 'package:adapty_flutter/models/adapty_purchaser_info.dart';
import 'package:adapty_flutter/results/get_paywalls_result.dart';
import 'package:adapty_flutter/results/make_purchase_result.dart';
import 'package:adapty_flutter/results/restore_purchases_result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final adaptyInterfaceProvider =
    Provider<AdaptyInterface>((ref) => const AdaptyInterface());

class AdaptyInterface {
  const AdaptyInterface();

  Future<void> identify(String customerUserId) =>
      Adapty.identify(customerUserId);

  Future<void> logout() => Adapty.logout();

  Future<GetPaywallsResult> fetchPaywalls() => Adapty.getPaywalls();

  Future<AdaptyPurchaserInfo> fetchPurchaserInfo() => Adapty.getPurchaserInfo();

  Future<MakePurchaseResult> makePurchase(
    AdaptyProduct product, {
    String? offerId,
  }) =>
      Adapty.makePurchase(product, offerId: offerId);

  Future<RestorePurchasesResult> restorePurchases() =>
      Adapty.restorePurchases();
}
