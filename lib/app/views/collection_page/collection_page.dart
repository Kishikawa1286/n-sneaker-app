import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utils/common_style.dart';
import '../../../utils/common_widgets/page_header.dart';
import '../../repositories/collection_product/collection_product_model.dart';
import 'background_image_selector_modal_bottom_sheet/background_image_selector_modal_bottom_sheet.dart';
import 'components/grid_tile.dart';
import 'view_model.dart';

class CollectionPage extends HookConsumerWidget {
  const CollectionPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(collectionPageProductGridViewModelProvider);
    final backgroundImagePath = viewModel.backgroundImagePath;
    return Material(
      child: Column(
        children: [
          PageHeader(
            title: 'コレクション',
            color: CommonStyle.scaffoldBackgroundColor,
            actions: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  showBackgroundImageSelectorModalBottomSheet(
                    context,
                    onTapTile: viewModel.setBackgroundImageIndex,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                  child: Icon(Icons.wallpaper),
                ),
              ),
            ],
          ),
          Flexible(
            child: viewModel.noCollectionProductExists
                ? Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            '👟',
                            maxLines: 1,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          Text(
                            'コレクションがありません',
                            maxLines: 1,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    decoration: backgroundImagePath != null
                        ? BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(backgroundImagePath),
                              fit: BoxFit.cover,
                              repeat: ImageRepeat.repeatY,
                            ),
                          )
                        : null,
                    child: PagedGridView<int, CollectionProductModel>(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      pagingController: viewModel.pagingController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.66,
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
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
          ),
        ],
      ),
    );
  }
}
