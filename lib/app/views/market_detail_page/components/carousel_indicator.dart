import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/common_style.dart';
import '../view_model.dart';

class MarketDetailPageCarouselIndicator extends HookConsumerWidget {
  const MarketDetailPageCarouselIndicator({required this.productId});

  final String productId;

  static const double _indicatorHeight = 6;
  static const double _verticalMargin = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(marketDetailPageViewModelProvider(productId));
    final product = viewModel.product;
    if (product == null) {
      return const SizedBox(height: _indicatorHeight + _verticalMargin * 2);
    }
    return Container(
      constraints: const BoxConstraints.expand(
        height: _indicatorHeight + _verticalMargin * 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<int>.generate(product.imageUrls.length, (index) => index)
            .map<Widget>(
              (index) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  viewModel.carouselController.animateToPage(index);
                },
                child: Container(
                  width: 20,
                  height: _indicatorHeight,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: _verticalMargin,
                  ),
                  decoration: BoxDecoration(
                    color: viewModel.carouselIndex == index
                        ? CommonStyle.enabledColor
                        : CommonStyle.disabledColor,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
