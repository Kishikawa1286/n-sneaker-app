import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'view_model.dart';

class UnityWidgetInitializer extends HookConsumerWidget {
  const UnityWidgetInitializer({required this.afterInitialized});

  final Widget Function(BuildContext) afterInitialized;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unityWidgetInitializerViewModel =
        ref.watch(unityWidgetInitializerViewModelProvider);
    if (unityWidgetInitializerViewModel.initialized) {
      return afterInitialized(context);
    }
    return Scaffold(
      body: Stack(
        children: [
          ColoredBox(
            color: Colors.white,
            child: Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const Image(
                    image: AssetImage('assets/launcher_icon/icon.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          UnityWidget(
            onUnityCreated: unityWidgetInitializerViewModel.onUnityCreated,
            fullscreen: true,
          ),
        ],
      ),
    );
  }
}
