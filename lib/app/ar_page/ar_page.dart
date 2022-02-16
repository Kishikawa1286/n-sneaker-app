import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'ar_page_view_model.dart';

class ARPage extends HookConsumerWidget {
  const ARPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arPageViewModel = ref.watch(arPageViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Page'),
      ),
      body: Stack(
        children: [
          UnityWidget(
            onUnityCreated: arPageViewModel.onUnityCreated,
            onUnitySceneLoaded: arPageViewModel.onUnitySceneLoaded,
            fullscreen: true,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 10,
              child: Column(
                children: <Widget>[
                  Slider(
                    onChanged: arPageViewModel.setIntensity,
                    value: arPageViewModel.intensity,
                    max: 10,
                    divisions: 50,
                    label: '明るさ',
                  ),
                  Slider(
                    onChanged: arPageViewModel.setTheta,
                    value: arPageViewModel.theta,
                    min: -180,
                    max: 180,
                    divisions: 30,
                    label: '水平方向',
                  ),
                  Slider(
                    onChanged: arPageViewModel.setPhi,
                    value: arPageViewModel.phi,
                    max: 90,
                    divisions: 30,
                    label: '高さ',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
