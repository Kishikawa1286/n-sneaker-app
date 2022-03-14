import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'ar_page_view_model.dart';

// url の生成を実装していないのでurlを渡さなければならない
// pushnameはできないので、直push
void pushARPage(
  BuildContext context, {
  required String productId,
  required String productGlbFileId,
  required String url,
}) =>
    Navigator.of(context).push(
      MaterialPageRoute<Widget>(
        builder: (context) => ARPage(
          productId: productId,
          productGlbFileId: productGlbFileId,
          url: url,
        ),
      ),
    );

class ARPage extends HookConsumerWidget {
  const ARPage({
    required this.productId,
    required this.productGlbFileId,
    required this.url,
  });

  final String productId;
  final String productGlbFileId;
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arPageViewModel = ref.watch(
      arPageViewModelProvider(
        '{"product_id": "$productId", "product_glb_file_id": "$productGlbFileId", "url": "$url"}',
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: arPageViewModel.capturing
          ? null
          : AppBar(
              leading: GestureDetector(
                onTap: () {
                  arPageViewModel.reloadUnityScene(justReload: true);
                  Navigator.of(context).pop();
                },
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.chevron_left),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: arPageViewModel.reloadUnityScene,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.replay_outlined),
                  ),
                ),
                GestureDetector(
                  onTap: arPageViewModel.captureAndShareScreenshot,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.camera_alt_outlined),
                  ),
                ),
              ],
              title: const Text('AR Page'),
            ),
      body: Stack(
        children: [
          UnityWidget(
            onUnityCreated: arPageViewModel.onUnityCreated,
            onUnityMessage: arPageViewModel.onUnityMessage,
          ),
          arPageViewModel.capturing
              ? const SizedBox()
              : Positioned(
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
                          onChanged:
                              arPageViewModel.onChangedShadowStrengthSlider,
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
                          max: 0,
                          min: -60,
                          divisions: 30,
                          label: '高さ',
                        ),
                      ],
                    ),
                  ),
                ),
          arPageViewModel.downloading
              ? Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 100,
                    child: Column(
                      children: [
                        const Text(
                          'Downloading',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            value: arPageViewModel.downloadProgress,
                            backgroundColor: Colors.grey,
                            color: Colors.white,
                            semanticsLabel: 'Downloading',
                            minHeight: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          arPageViewModel.loading
              ? Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 100,
                    child: Column(
                      children: [
                        const Text(
                          'Loading',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            value: arPageViewModel.loadProgress,
                            backgroundColor: Colors.grey,
                            color: Colors.white,
                            semanticsLabel: 'Loading',
                            minHeight: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
