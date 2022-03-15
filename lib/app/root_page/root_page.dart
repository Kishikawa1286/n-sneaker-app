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
                productId: 'Cheese',
                productGlbFileId: 'BOTH',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fcheese_both.glb?alt=media&token=eb51bf14-447b-4f7f-b3a7-d36c7b43e140',
              ),
              _Tile(
                productId: 'Guns 1 郷愁',
                productGlbFileId: 'BOTH',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fguns1_kyosyu_both.glb?alt=media&token=c8701a5f-d9ef-47e2-a340-35935c0d38eb',
              ),
              _Tile(
                productId: 'Guns 1 Orange',
                productGlbFileId: 'BOTH',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fguns1_orenge_both.glb?alt=media&token=24a20694-05be-4786-ad3a-2f390e1b8d54',
              ),
              _Tile(
                productId: 'Jet 1 Camouflage',
                productGlbFileId: 'BOTH',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fjet1_camouflage_both.glb?alt=media&token=7ec91aaf-7981-4461-85b0-c8efedcbf740',
              ),
              _Tile(
                productId: 'Money',
                productGlbFileId: 'BOTH',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fmoney_both.glb?alt=media&token=477e1e8a-5b74-4435-844d-badd0c257ff0',
              ),
              _Tile(
                productId: 'Guns',
                productGlbFileId: 'MRMIND',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fmr_mind_guns.glb?alt=media&token=940a5045-33a7-4cfa-8233-e2a0fcd1f2c1',
              ),
              _Tile(
                productId: 'Mark',
                productGlbFileId: 'MRMIND',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fmr_mind_mark.glb?alt=media&token=49797596-d6b1-4e11-ab2a-36120ef8a0ed',
              ),
              _Tile(
                productId: 'MyName',
                productGlbFileId: 'ONE',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fmy_name.glb?alt=media&token=f606d49d-2010-4217-b282-d7dfb0076b48',
              ),
              _Tile(
                productId: 'MyName',
                productGlbFileId: 'BOTH',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fmy_name_both.glb?alt=media&token=240c89a6-efe5-4a2e-9990-5342703c8ccc',
              ),
              _Tile(
                productId: 'Mark Red',
                productGlbFileId: 'BOTH',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fred_mark_both.glb?alt=media&token=ca3d0af9-1742-478c-b331-34e360ba3b7a',
              ),
              _Tile(
                productId: 'Wave Tiger',
                productGlbFileId: 'BOTH',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fwave_tiger_both.glb?alt=media&token=fcb212c1-ecc3-44f5-97cd-de5483592a66',
              ),
              _Tile(
                productId: 'Mark White',
                productGlbFileId: 'BOTH',
                url:
                    'https://firebasestorage.googleapis.com/v0/b/n-sneaker-development.appspot.com/o/test%2Fwhite_mark_both.glb?alt=media&token=ebd9b86b-c410-4bb2-915b-a0e73e461363',
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
