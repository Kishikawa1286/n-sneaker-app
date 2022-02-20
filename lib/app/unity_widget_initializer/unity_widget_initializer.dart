import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../ar_page/ar_page_view_model.dart';
import 'unity_widget_initializer_view_model.dart';

class UnityWidgetInitializer extends HookConsumerWidget {
  const UnityWidgetInitializer({required this.afterInitialized});

  final Scaffold Function(BuildContext) afterInitialized;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unityWidgetInitializerViewModel =
        ref.watch(unityWidgetInitializerViewModelProvider);
    final arPageViewModel = ref.watch(arPageViewModelProvider);
    if (unityWidgetInitializerViewModel.initialized) {
      return afterInitialized(context);
    }
    return Scaffold(
      body: Stack(
        children: [
          const ColoredBox(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
          SizedBox(
            width: 0,
            height: 0,
            child: UnityWidget(
              onUnityCreated: arPageViewModel.onUnityCreated,
              fullscreen: true,
            ),
          ),
        ],
      ),
    );
  }
}
