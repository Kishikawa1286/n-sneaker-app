import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../utils/common_style.dart';
import '../../../repositories/product_glb_file/product_glb_file.dart';

class GlbFileSelectorModalBottomSheetGridTile extends StatelessWidget {
  const GlbFileSelectorModalBottomSheetGridTile({
    required this.productGlbFileModel,
    required this.onTap,
  });

  final ProductGlbFileModel productGlbFileModel;
  final void Function(ProductGlbFileModel) onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          onTap(productGlbFileModel);
        },
        behavior: HitTestBehavior.opaque,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: CachedNetworkImage(
            imageUrl: productGlbFileModel.imageUrls.first,
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
                color: CommonStyle.grey,
              ),
            ),
          ),
        ),
      );
}
