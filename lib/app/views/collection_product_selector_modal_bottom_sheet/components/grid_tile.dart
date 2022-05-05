import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../utils/common_style.dart';
import '../../../repositories/collection_product/collection_product_model.dart';

class CollectionProductSelectorModalBottomSheetGridTile
    extends StatelessWidget {
  const CollectionProductSelectorModalBottomSheetGridTile({
    required this.collectionProduct,
    required this.onTapTile,
  });

  final CollectionProductModel collectionProduct;
  final void Function(CollectionProductModel) onTapTile;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          onTapTile(collectionProduct);
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
              collectionProduct.isTrial
                  ? Positioned(
                      height: 27,
                      top: 5,
                      right: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: CommonStyle.themeColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 2),
                        child: const Center(
                          child: Text(
                            'トライアル',
                            style: TextStyle(
                              fontSize: 11,
                              color: CommonStyle.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      );
}
