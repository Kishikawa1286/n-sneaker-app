import 'dart:io';

import '../../../utils/environment_variables.dart';

const revenueCatIosPublicKey = 'appl_ohmlaqCYRtdfmrWDuoEQhBFZuGT';

const revenueCatAndroidPublicKey = 'goog_qeeruKlgYADMJqVncdBnSOrGmir';

String revenueCatProductIdentifier(String firebaseProductId) {
  if (flavor == 'prod') {
    if (Platform.isIOS) {
      return 'nsneaker.app_store.$firebaseProductId';
    }
    if (Platform.isAndroid) {
      return 'nsneaker.play_store.$firebaseProductId';
    }
  } else {
    if (Platform.isIOS) {
      return 'nsneakerdev.app_store.$firebaseProductId';
    }
    if (Platform.isAndroid) {
      return 'nsneakerdev.play_store.$firebaseProductId';
    }
  }
  throw Exception('invalid environment. you cannnot use in-app purchase.');
}
