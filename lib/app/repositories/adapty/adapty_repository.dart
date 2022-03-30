import 'package:adapty_flutter/models/adapty_product.dart';
import 'package:adapty_flutter/models/adapty_purchaser_info.dart';
import 'package:adapty_flutter/results/get_paywalls_result.dart';
import 'package:adapty_flutter/results/make_purchase_result.dart';
import 'package:adapty_flutter/results/restore_purchases_result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/adapty/adapty_interface.dart';

final adaptyRepositoryProvider = Provider<AdaptyRepository>(
  (ref) => AdaptyRepository(ref.read(adaptyInterfaceProvider)),
);

class AdaptyRepository {
  const AdaptyRepository(this._adaptyInterface);

  final AdaptyInterface _adaptyInterface;

  Future<void> identify(String accountId) =>
      _adaptyInterface.identify(accountId);

  Future<void> logout() => _adaptyInterface.logout();

  Future<GetPaywallsResult> fetchPaywalls() => _adaptyInterface.fetchPaywalls();

  Future<AdaptyPurchaserInfo> fetchPurchaserInfo() =>
      _adaptyInterface.fetchPurchaserInfo();

  Future<MakePurchaseResult> makePurchase(AdaptyProduct product) =>
      _adaptyInterface.makePurchase(product);

  Future<RestorePurchasesResult?> restorePurchase(String productId) async {
    final result = await _adaptyInterface.restorePurchases();
    if (result.purchaserInfo?.accessLevels[productId] == null) {
      return null;
    }
    return result;
  }
}
