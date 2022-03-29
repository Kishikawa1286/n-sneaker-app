import 'package:adapty_flutter/models/adapty_paywall.dart';
import 'package:adapty_flutter/results/make_purchase_result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/adapty/adapty_repository.dart';

final adaptyServiceProvider = Provider<AdaptyService>(
  (ref) => AdaptyService(ref.read(adaptyRepositoryProvider)),
);

class AdaptyService {
  AdaptyService(this._adaptyRepository);

  final AdaptyRepository _adaptyRepository;

  Map<String, AdaptyPaywall>? _paywalls;

  Future<void> _init() async {
    try {
      final result = await _adaptyRepository.fetchPaywalls();
      final pws = result.paywalls;
      if (pws == null) {
        throw Exception('no paywall exists.');
      }
      _paywalls =
          pws.where((pw) => pw.developerId != null).toList().asMap().map(
                // pw.developerId is never null
                (index, pw) => MapEntry(pw.developerId ?? '', pw),
              );
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<MakePurchaseResult?> makePurchase(String productId) async {
    try {
      if (_paywalls == null) {
        await _init();
      }
      final purchaserInfo = await _adaptyRepository.fetchPurchaserInfo();
      // access level は productId を ID として登録されている
      if (purchaserInfo.accessLevels[productId] != null) {
        throw Exception('access level is already granted.');
      }
      // paywall は productId を ID として登録されている
      final adaptyProducts = _paywalls?[productId]?.products;
      if (adaptyProducts == null) {
        throw Exception('no adapty products exists.');
      }
      if (adaptyProducts.isEmpty) {
        throw Exception('no adapty products exists.');
      }
      // 1 paywall 1 product の設定
      final adaptyProduct = adaptyProducts.first;
      final result = await _adaptyRepository.makePurchase(adaptyProduct);
      return result;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
}
