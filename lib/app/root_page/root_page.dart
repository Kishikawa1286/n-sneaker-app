import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../ar_page/ar_page.dart';
import '../unity_widget_initializer/unity_widget_initializer.dart';

class RootPage extends HookConsumerWidget {
  const RootPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) => UnityWidgetInitializer(
        afterInitialized: (context) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Root Page',
              style: TextStyle(fontSize: 28),
            ),
          ),
          body: ListView(
            children: const [
              _Tile(
                productId: 'MyName',
                productGlbFileId: 'ONE-1',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fmy_name.glb?alt=media&token=f606d49d-2010-4217-b282-d7dfb0076b48',
              ),
              _Tile(
                productId: 'MyName',
                productGlbFileId: 'BOTH-1',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fmy_name_both.glb?alt=media&token=240c89a6-efe5-4a2e-9990-5342703c8ccc',
              ),
            ],
          ),
        ),
      );
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.productId,
    required this.productGlbFileId,
    required this.url,
  });

  final String productId;
  final String productGlbFileId;
  final String url;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          pushARPage(
            context,
            productId: productId,
            productGlbFileId: productGlbFileId,
            url: url,
          );
        },
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(border: Border()),
          child: Center(child: Text('${productId}_$productGlbFileId')),
        ),
      );
}
