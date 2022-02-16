import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  const RootPage();

  @override
  Widget build(BuildContext context) => Scaffold(
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
      );
}
