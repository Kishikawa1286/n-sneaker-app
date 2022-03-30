// ignore_for_file: constant_identifier_names

import 'dart:io';

enum PaymentMethod {
  play_store_in_app_purchase,
  app_store_in_app_purchase,
  unknown,
}

PaymentMethod generatePaymentMethodFromDevice() {
  if (Platform.isAndroid) {
    return PaymentMethod.play_store_in_app_purchase;
  }
  if (Platform.isIOS) {
    return PaymentMethod.app_store_in_app_purchase;
  }
  return PaymentMethod.unknown;
}

PaymentMethod generatePaymentMethodFromAdaptyStoreInfo(String? store) {
  if (store == 'play_store') {
    return PaymentMethod.play_store_in_app_purchase;
  }
  if (store == 'app_store') {
    return PaymentMethod.app_store_in_app_purchase;
  }
  return PaymentMethod.unknown;
}
