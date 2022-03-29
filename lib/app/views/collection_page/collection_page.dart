import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utils/common_widgets/page_header.dart';
import '../../repositories/collection_product/collection_product_model.dart';
import 'components/grid_tile.dart';
import 'view_model.dart';

class CollectionPage extends HookConsumerWidget {
  const CollectionPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(collectionPageProductGridViewModelProvider);
    return Material(
      child: Stack(
        children: [
          const PageHeader(title: 'コレクション'),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: PagedGridView<int, CollectionProductModel>(
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
              builderDelegate:
                  PagedChildBuilderDelegate<CollectionProductModel>(
                itemBuilder: (context, collectionProduct, index) =>
                    CollectionPageProductGridTile(
                  collectionProduct: collectionProduct,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
