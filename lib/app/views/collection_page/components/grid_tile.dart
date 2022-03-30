import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../utils/common_style.dart';
import '../../../repositories/collection_product/collection_product_model.dart';
import '../../glb_file_selector_modal_bottom_sheet/glb_file_selector_modal_bottom_sheet.dart';
import '../../glb_file_viewer_page/glb_file_viewer_page.dart';

class CollectionPageProductGridTile extends StatelessWidget {
  const CollectionPageProductGridTile({required this.collectionProduct});

  final CollectionProductModel collectionProduct;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          showGlbFileSelectorModalBottomSheet(
            context,
            productId: collectionProduct.productId,
            onTapTile: (productGlbFile) => pushGlbFileViewerPage(
              context,
              productId: collectionProduct.productId,
              productGlbFileId: productGlbFile.id,
            ),
          );
        },
        behavior: HitTestBehavior.opaque,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: collectionProduct.tileImageUrls.first,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageProvider,
                              ),
                            ),
                          ),
                          placeholder: (_, __) => Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7),
                              ),
                              color: CommonStyle.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 7,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${collectionProduct.vendorJp}  ${collectionProduct.seriesJp}',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          collectionProduct.titleJp,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
