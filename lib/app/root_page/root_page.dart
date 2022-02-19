import 'package:flutter/material.dart';
import '../unity_widget_initializer/unity_widget_initializer.dart';

class RootPage extends StatelessWidget {
  const RootPage();

  @override
  Widget build(BuildContext context) => UnityWidgetInitializer(
        afterInitialized: Scaffold(
          appBar: AppBar(
            title: const Text('Root Page'),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/arpage');
              },
              child: const Text('Start AR'),
            ),
          ),
        ),
      );
}
