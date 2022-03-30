import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utils/common_widgets/page_header.dart';
import '../../repositories/collection_product/collection_product_model.dart';
import 'components/grid_tile.dart';
import 'view_model.dart';

void showCollectionProductSelectorModalBottomSheet(
  BuildContext context, {
  required void Function(CollectionProductModel) onTapTile,
}) {
  showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    builder: (context) => CollectionProductSelectorModalBottomSheet(
      onTapTile: onTapTile,
    ),
  );
}

class CollectionProductSelectorModalBottomSheet extends HookConsumerWidget {
  const CollectionProductSelectorModalBottomSheet({required this.onTapTile});

  final void Function(CollectionProductModel) onTapTile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel =
        ref.watch(collectionProductSelectorModalBottomSheetViewModelProvider);
    return Column(
      children: [
        const PageHeader(title: 'スニーカーを選択', height: 35),
        Flexible(
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
            builderDelegate: PagedChildBuilderDelegate<CollectionProductModel>(
              itemBuilder: (context, collectionProduct, index) =>
                  CollectionProductSelectorModalBottomSheetGridTile(
                collectionProduct: collectionProduct,
                onTapTile: onTapTile,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
