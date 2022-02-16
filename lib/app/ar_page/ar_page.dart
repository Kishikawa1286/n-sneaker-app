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
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: arPageViewModel.reloadUnityScene,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.replay_outlined),
            ),
          )
        ],
        title: const Text('AR Page'),
      ),
      body: Stack(
        children: [
          UnityWidget(
            onUnityCreated: arPageViewModel.onUnityCreated,
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
                    onChanged: arPageViewModel.onChangedIntensitySlider,
                    value: arPageViewModel.intensity,
                    max: 10,
                    divisions: 50,
                    label: '明るさ',
                  ),
                  Slider(
                    onChanged: arPageViewModel.onChangedShadowStrengthSlider,
                    value: arPageViewModel.shadowStrength,
                    divisions: 20,
                    label: '影の濃さ',
                  ),
                  Slider(
                    onChanged: arPageViewModel.onChangedThetaSlider,
                    value: arPageViewModel.theta,
                    min: -180,
                    max: 180,
                    divisions: 30,
                    label: '水平方向',
                  ),
                  Slider(
                    onChanged: arPageViewModel.onChangedPhiSlider,
                    value: arPageViewModel.phi,
                    max: 60,
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
