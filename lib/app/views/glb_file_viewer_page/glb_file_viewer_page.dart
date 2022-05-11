import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../utils/common_style.dart';
import '../../../utils/common_widgets/floating_back_button.dart';
import 'view_model.dart';

void pushGlbFileViewerPage(
  BuildContext context, {
  required String productId,
  required String productGlbFileId,
}) {
  Navigator.of(context)
      .pushNamed('glb_file_viewer/$productId/$productGlbFileId');
}

class GlbFileViewerPage extends HookConsumerWidget {
  const GlbFileViewerPage({
    required this.productId,
    required this.productGlbFileId,
  });

  final String productId;
  final String productGlbFileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(
      glbFileViewerPageViewModelProvider('$productId, $productGlbFileId'),
    );

    if (!viewModel.initialized) {
      return Scaffold(
        backgroundColor: CommonStyle.scaffoldBackgroundColor,
        body: Stack(
          clipBehavior: Clip.none,
          children: const [
            Positioned(
              top: 40,
              left: 5,
              child: FloatingBackButton(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: CommonStyle.scaffoldBackgroundColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          viewModel.fileExists
              ? SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ModelViewer(
                      src: 'file://${viewModel.glbFileModel.filePath}',
                      alt: 'Model Viewer',
                      ar: false,
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    value: viewModel.downloadProgress,
                    color: CommonStyle.themeColor,
                  ),
                ),
          const Positioned(
            top: 40,
            left: 5,
            child: FloatingBackButton(),
          ),
        ],
      ),
    );
  }
}
