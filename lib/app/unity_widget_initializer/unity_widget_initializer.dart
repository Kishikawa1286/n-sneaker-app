import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'unity_widget_initializer_view_model.dart';

class UnityWidgetInitializer extends HookConsumerWidget {
  const UnityWidgetInitializer({required this.afterInitialized});

  final Scaffold afterInitialized;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(unityWidgetInitializerViewModelProvider);
    print(viewModel.initialized);
    if (viewModel.initialized) {
      return afterInitialized;
    }
    return Scaffold(
      body: Stack(
        children: [
          const ColoredBox(
            color: Colors.white,
            child: Expanded(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
          SizedBox(
            width: 0,
            height: 0,
            child: UnityWidget(
              onUnityCreated: (_) {},
              fullscreen: true,
            ),
          ),
        ],
      ),
    );
  }
}
