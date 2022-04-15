import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/common_style.dart';
import '../ar_glb_file_selector_modal_bottom_sheet/viewer_glb_file_selector_modal_bottom_sheet.dart';
import '../collection_product_selector_modal_bottom_sheet/collection_product_selector_modal_bottom_sheet.dart';
import 'view_model.dart';

class ArPage extends HookConsumerWidget {
  const ArPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(arPageViewModelProvider);
    final productGlbFile = viewModel.productGlbFile;

    if (viewModel.noCollectionProductExists) {
      return Padding(
        padding: const EdgeInsets.only(top: 150),
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
      );
    }

    return Column(
      children: [
        Container(
          color: CommonStyle.black,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 180,
          child: viewModel.initialized
              ? UnityWidget(
                  key: viewModel.unityWidgetKey,
                  onUnityCreated: viewModel.onUnityCreated,
                  onUnityMessage: viewModel.onUnityMessage,
                  useAndroidViewSurface: true,
                )
              : const SizedBox(),
        ),
        Card(
          elevation: 5,
          margin: const EdgeInsets.only(top: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: !viewModel.initialized
                ? const SizedBox()
                : productGlbFile == null
                    ? ListTile(
                        title: Text(
                          'コレクションがありません👟',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )
                    : ListTile(
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: CachedNetworkImage(
                            imageUrl: productGlbFile.imageUrls.first,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(7),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: imageProvider,
                                ),
                              ),
                            ),
                            placeholder: (_, __) => Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                color: CommonStyle.grey,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          productGlbFile.titleJp,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onTap: () {
                          showCollectionProductSelectorModalBottomSheet(
                            context,
                            onTapTile: (collectionProduct) =>
                                showArGlbFileSelectorModalBottomSheet(
                              context,
                              productId: collectionProduct.productId,
                              onTapTile: (selected) {
                                viewModel.selectGlbFile(selected);
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }
}
