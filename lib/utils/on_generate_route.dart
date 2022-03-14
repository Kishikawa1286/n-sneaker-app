import 'package:flutter/material.dart';

import '../app/root_page/root_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) =>
    MaterialPageRoute<Widget>(
      builder: (context) {
        final name = settings.name;
        if (name == null || name == 'root') {
          return const RootPage();
        }

        return const RootPage();
      },
    );
