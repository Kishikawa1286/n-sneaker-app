import 'package:flutter/material.dart';

import '../app/ar_page/ar_page.dart';
import '../app/root_page/root_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) =>
    PageRouteBuilder<Widget>(
      settings: settings,
      pageBuilder: (_, __, ___) {
        switch (settings.name) {
          case '/':
            return const RootPage();
          case '/arpage':
            return const ARPage();
          default:
            return const Scaffold();
        }
      },
    );
