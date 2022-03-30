import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../utils/common_style.dart';
import '../../../../../utils/common_widgets/page_header.dart';
import '../../repositories/product_glb_file/product_glb_file.dart';
import 'components/grid_tile.dart';
import 'view_model.dart';

void showGlbFileSelectorModalBottomSheet(
  BuildContext context, {
  required String productId,
  required void Function(ProductGlbFileModel) onTapTile,
}) {
  showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    builder: (context) => GlbFileSelectorModalBottomSheet(
      productId: productId,
      onTapTile: onTapTile,
    ),
  );
}

class GlbFileSelectorModalBottomSheet extends HookConsumerWidget {
  GlbFileSelectorModalBottomSheet({
    required this.productId,
    required this.onTapTile,
  });

  final String productId;
  final void Function(ProductGlbFileModel) onTapTile;

  final _placeholder = Container(color: CommonStyle.scaffoldBackgroundColor);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel =
        ref.watch(glbFileSelectorModalBottomSheetViewModelProvider(productId));
    final glbFileModels = viewModel.glbFileModels;

    if (glbFileModels == null) {
      return _placeholder;
    }
    if (glbFileModels.isEmpty) {
      return _placeholder;
    }

    final productVendor = glbFileModels.first.productVendorJp;
    final productSeries = glbFileModels.first.productSeriesJp;
    final productTitle = glbFileModels.first.productTitleJp;
    return Column(
      children: [
        PageHeader(
          title: '$productVendor  $productSeries\n$productTitle',
          height: 50,
        ),
        Flexible(
          child: GridView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            children: glbFileModels
                .map(
                  (glbFileModel) => GlbFileSelectorModalBottomSheetGridTile(
                    productGlbFileModel: glbFileModel,
                    onTap: onTapTile,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
