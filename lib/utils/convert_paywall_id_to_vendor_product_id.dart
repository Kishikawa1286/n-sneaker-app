import 'dart:io';

import 'environment_variables.dart';

String convertPaywallIdToVendorProductId(String paywallId) {
  if (Platform.isAndroid) {
    if (flavor == 'prod') {
      return 'com.nevermind.nsneaker.play_store.$paywallId';
    }
    return 'com.nevermind.nsneakerdev.play_store.$paywallId';
  }
  if (Platform.isIOS) {
    if (flavor == 'prod') {
      return 'com.nevermind.nsneaker.app_store.$paywallId';
    }
    return 'com.nevermind.nsneakerdev.app_store.$paywallId';
  }
  return '';
}
