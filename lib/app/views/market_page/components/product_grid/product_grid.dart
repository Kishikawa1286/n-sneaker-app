import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../repositories/product/product_model.dart';
import 'grid_tile.dart';
import 'view_model.dart';

class MarketPageProductGrid extends HookConsumerWidget {
  const MarketPageProductGrid({required this.series});

  final String series;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(marketPageProductGridViewModelProvider(series));
    return PagedGridView<int, ProductModel>(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 8,
      ),
      pagingController: viewModel.pagingController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      builderDelegate: PagedChildBuilderDelegate<ProductModel>(
        itemBuilder: (context, product, index) =>
            MarketPageProductGridTile(product: product),
      ),
    );
  }
}
