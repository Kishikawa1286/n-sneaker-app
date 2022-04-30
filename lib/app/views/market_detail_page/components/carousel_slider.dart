import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/common_style.dart';
import '../view_model.dart';

class MarketDetailPageCarouselSlider extends HookConsumerWidget {
  const MarketDetailPageCarouselSlider({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(marketDetailPageViewModelProvider(productId));
    final product = viewModel.product;
    final width = MediaQuery.of(context).size.width;
    if (product == null) {
      return Container(
        width: width,
        height: width,
        decoration: const BoxDecoration(color: CommonStyle.white),
      );
    }
    return CarouselSlider(
      carouselController: viewModel.carouselController,
      options: CarouselOptions(
        height: width * 4 / 3,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          viewModel.setCarouselIndex(index);
        },
      ),
      items: product.imageUrls
          .map(
            (url) => CachedNetworkImage(
              fadeInDuration: const Duration(milliseconds: 2000),
              imageUrl: url,
              imageBuilder: (context, imageProvider) => Center(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        url,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              placeholder: (_, __) => Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: CommonStyle.grey,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
