import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utils/common_style.dart';
import '../../../utils/common_widgets/page_header.dart';
import '../../repositories/gallery_post/gallery_post_model.dart';
import 'component/gallery_image_viewer.dart';
import 'view_model.dart';

class GalleryPage extends HookConsumerWidget {
  const GalleryPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(galleryPageViewModelProvider);
    return Material(
      child: Column(
        children: [
          const PageHeader(
            title: 'ギャラリー',
            color: CommonStyle.scaffoldBackgroundColor,
          ),
          Flexible(
            child: PagedGridView<int, GalleryPostModel>(
              padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 2,
              ),
              pagingController: viewModel.pagingController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              builderDelegate: PagedChildBuilderDelegate<GalleryPostModel>(
                itemBuilder: (context, galleryPost, index) => GestureDetector(
                  onTap: () => context.pushTransparentRoute(
                    GalleryImageViewer(galleryPostId: galleryPost.id),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: galleryPost.compressedImageUrls.first,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        ),
                      ),
                    ),
                    placeholder: (_, __) => Container(
                      decoration: const BoxDecoration(
                        color: CommonStyle.transparentBlack,
                      ),
                    ),
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
