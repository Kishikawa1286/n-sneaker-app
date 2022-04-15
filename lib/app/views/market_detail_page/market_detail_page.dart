import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/common_widgets/floating_back_button.dart';
import '../../../utils/common_widgets/overlay_loading.dart';
import 'components/carousel_indicator.dart';
import 'components/carousel_slider.dart';
import 'components/description.dart';
import 'components/purchase_button.dart';
import 'view_model.dart';

void pushMarketDetailPage(BuildContext context, {required String productId}) {
  Navigator.of(context).pushNamed('product_detail/$productId');
}

class MarketDetailPage extends HookConsumerWidget {
  const MarketDetailPage({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(marketDetailPageViewModelProvider(productId));
    return Scaffold(
      key: viewModel.scaffoldKey,
      endDrawer: viewModel.purchased ?? true
          ? null
          : Drawer(
              child: ListView(
                padding: const EdgeInsets.only(top: 50),
                children: [
                  ListTile(
                    onTap: () async {
                      final message = await viewModel.restore();
                      if (message.isNotEmpty) {
                        await Flushbar<void>(
                          message: message,
                          duration: const Duration(seconds: 3),
                        ).show(context);
                      }
                    },
                    leading: const Icon(Icons.replay),
                    title: const Text('決済状態を復元する'),
                  ),
                ],
              ),
            ),
      body: OverlayLoading(
        visible: viewModel.purchaseInProgress,
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: MarketDetailPageCarouselSlider(productId: productId),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: MarketDetailPageCarouselIndicator(
                    productId: productId,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45),
                  child: MarketDetailPageDescription(productId: productId),
                ),
              ],
            ),
            const Positioned(
              top: 40,
              left: 5,
              child: FloatingBackButton(),
            ),
            Positioned(
              bottom: 15,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: MarketDetailPagePurchaseButton(productId: productId),
                ),
              ),
            ),
            // Drawer の要素が購入の復元のみなので購入済みなら表示しない
            viewModel.purchased ?? true
                ? const SizedBox()
                : Positioned(
                    top: 40,
                    right: 5,
                    child: IconButton(
                      onPressed:
                          viewModel.scaffoldKey.currentState?.openEndDrawer,
                      icon: const Icon(Icons.menu, size: 30),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
