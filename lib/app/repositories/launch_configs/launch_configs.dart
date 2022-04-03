import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class LaunchConfigsModel {
  const LaunchConfigsModel({
    required this.iosLaunchableBuildNumber,
    required this.androidLaunchableBuildNumber,
    required this.underMaintenance,
    required this.maintainanceMessage,
  });

  factory LaunchConfigsModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('DocumentSnapshot.data() of launch configs is null.');
    }
    return LaunchConfigsModel(
      iosLaunchableBuildNumber: data['ios_launchable_build_number'] as int,
      androidLaunchableBuildNumber:
          data['android_launchable_build_number'] as int,
      underMaintenance: data['under_maintenance'] as bool,
      maintainanceMessage: data['maintenance_message'] as String,
    );
  }

  final int iosLaunchableBuildNumber;
  final int androidLaunchableBuildNumber;
  final bool underMaintenance;
  final String maintainanceMessage;

  int get launchableBuildNumber {
    if (Platform.isIOS) {
      return iosLaunchableBuildNumber;
    }
    if (Platform.isAndroid) {
      return androidLaunchableBuildNumber;
    }
    return 0;
  }
}
