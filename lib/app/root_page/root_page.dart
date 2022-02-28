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
                      id: 'sneaker-Guns-1',
                      url:
                          'https://firebasestorage.googleapis.com/v0/b/n-sneaker-temp.appspot.com/o/test%2FGuns.zip?alt=media&token=0655f270-ebe8-48d9-89d7-8b2e883f2d06',
                    );
                    Navigator.of(context).pushNamed('/arpage');
                  },
                  child: const Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Guns',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                // Guns
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    arPageViewModel.onSelected3DModel(
                      id: 'sneaker-Sckelton-4',
                      url:
                          'https://firebasestorage.googleapis.com/v0/b/n-sneaker-temp.appspot.com/o/test%2Fsckelton%202.zip?alt=media&token=dbee3386-3673-4f90-8173-9c3570e7cdc2',
                    );
                    Navigator.of(context).pushNamed('/arpage');
                  },
                  child: const Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Sckelton',
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
