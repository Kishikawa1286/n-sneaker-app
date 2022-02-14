import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

void main() {
  runApp(const MaterialApp(home: UnityDemoScreen()));
}

class UnityDemoScreen extends StatefulWidget {
  const UnityDemoScreen();

  @override
  _UnityDemoScreenState createState() => _UnityDemoScreenState();
}

class _UnityDemoScreenState extends State<UnityDemoScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          bottom: false,
          child: WillPopScope(
            onWillPop: () async {
              print('popped');
              return true;
            },
            child: Container(
              color: Colors.yellow,
              child: UnityWidget(
                onUnityCreated: onUnityCreated,
                fullscreen: true,
              ),
            ),
          ),
        ),
      );

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(UnityWidgetController controller) {}
}
