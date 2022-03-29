import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'utils/on_generate_route.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // 縦画面固定
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );
      if (Platform.isAndroid) {
        // ナビゲーションバーを消す
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
      await Firebase.initializeApp();
      runApp(
        ProviderScope(
          child: MaterialApp(
            title: 'n-sneaker',
            onGenerateRoute: onGenerateRoute,
            initialRoute: 'root',
            theme: ThemeData(
              brightness: Brightness.light,
              fontFamily: 'MPLUS1',
            ),
          ),
        ),
      );
    },
    (error, stackTrace) async {
      print('runZonedGuarded: Caught error in my root zone.');
      print('error\n$error');
      print('stacktrace\n$stackTrace');
    },
  );
}
