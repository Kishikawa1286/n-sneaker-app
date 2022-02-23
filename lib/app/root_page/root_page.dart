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
                      id: 'sneaker-1',
                      url:
                          'https://firebasestorage.googleapis.com/v0/b/n-sneaker-dev.appspot.com/o/test%2FMyName.zip?alt=media&token=bf31730b-bcf8-4d07-af30-aebdc246cd2f',
                    );
                    Navigator.of(context).pushNamed('/arpage');
                  },
                  child: const Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'My Name',
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
                      id: 'sneaker-2',
                      url:
                          'https://firebasestorage.googleapis.com/v0/b/n-sneaker-dev.appspot.com/o/test%2FGuns.zip?alt=media&token=fc6031c9-4656-42f0-a2de-cd560c52c741',
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
              ],
            ),
          );
        },
      );
}
