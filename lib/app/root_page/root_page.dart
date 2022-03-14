import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../ar_page/ar_page_view_model.dart';
import '../unity_widget_initializer/unity_widget_initializer.dart';

class RootPage extends HookConsumerWidget {
  const RootPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) => UnityWidgetInitializer(
        afterInitialized: (context) {
          final arPageViewModel = ref.watch(arPageViewModelProvider);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Root Page',
                style: TextStyle(fontSize: 28),
              ),
            ),
            body: Column(
              children: [
                // My Name
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    arPageViewModel.onSelected3DModel(
                      id: 'my-name-one-1',
                      url:
                          'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fmy_name.glb?alt=media&token=f606d49d-2010-4217-b282-d7dfb0076b48',
                    );
                    Navigator.of(context).pushNamed('/arpage');
                  },
                  child: const Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'My Name (one)',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ), // My Name
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    arPageViewModel.onSelected3DModel(
                      id: 'my-name-both-1',
                      url:
                          'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fmy_name_both.glb?alt=media&token=240c89a6-efe5-4a2e-9990-5342703c8ccc',
                    );
                    Navigator.of(context).pushNamed('/arpage');
                  },
                  child: const Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'My Name (both)',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                // Mr.Mind
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    arPageViewModel.onSelected3DModel(
                      id: 'mr-mind',
                      url:
                          'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fmr_mind.glb?alt=media&token=d8b33c03-d042-4796-8864-6c63ea830eb3',
                    );
                    Navigator.of(context).pushNamed('/arpage');
                  },
                  child: const Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Mr Mind',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}
