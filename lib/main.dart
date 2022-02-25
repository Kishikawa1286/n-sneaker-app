import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'utils/on_generate_route.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      await PackageInfo.fromPlatform().then((value) {
        print(value.appName);
        print(value.packageName);
      });
      runApp(
        const ProviderScope(
          child: MaterialApp(
            title: 'n-sneaker',
            onGenerateRoute: onGenerateRoute,
            initialRoute: '/',
          ),
        ),
      );
    },
    (error, stackTrace) async {
      print('runZonedGuarded: Caught error in my root zone.');
      print('--- error ---\n$error\n-------------');
      print('--- stackTrace ---\n$stackTrace\n------------------');
    },
  );
}
