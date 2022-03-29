import 'package:adapty_flutter/models/adapty_product.dart';
import 'package:adapty_flutter/models/adapty_purchaser_info.dart';
import 'package:adapty_flutter/results/get_paywalls_result.dart';
import 'package:adapty_flutter/results/make_purchase_result.dart';
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

  Future<MakePurchaseResult> makePurchase(
    AdaptyProduct product, {
    String? offerId,
  }) =>
      _adaptyInterface.makePurchase(product, offerId: offerId);
}
