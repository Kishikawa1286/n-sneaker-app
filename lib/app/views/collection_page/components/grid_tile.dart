import 'package:blur/blur.dart';
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
          color: CommonStyle.transparent,
          elevation: 0,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 100,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: CommonStyle.transparentBlack,
                    borderRadius: BorderRadius.all(Radius.elliptical(50, 10)),
                  ),
                ),
              ),
              CachedNetworkImage(
                imageUrl:
                    collectionProduct.transparentBackgroundImageUrls.first,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: imageProvider,
                    ),
                  ),
                ),
                placeholder: (_, __) => Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: CommonStyle.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
