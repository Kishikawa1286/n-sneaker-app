import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utils/common_style.dart';
import '../../../utils/common_widgets/page_header.dart';
import '../../repositories/gallery_post/gallery_post_model.dart';
import 'component/image_viewer.dart';
import 'view_model.dart';

void pushAccountGalleryPostsPage(BuildContext context) {
  Navigator.of(context).pushNamed('account_gallery_posts');
}

class AccountGalleryPostsPage extends HookConsumerWidget {
  const AccountGalleryPostsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(accountGalleryPostsPageViewModelProvider);
    final itemList = viewModel.pagingController.itemList;

    if (itemList == null) {
      return Scaffold(
        body: Column(
          children: [
            const PageHeader(
              title: '自分の投稿',
              color: CommonStyle.scaffoldBackgroundColor,
              showBackButton: true,
            ),
            Flexible(
              child: PagedGridView<int, GalleryPostModel>(
                pagingController: viewModel.pagingController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                builderDelegate: PagedChildBuilderDelegate<GalleryPostModel>(
                  itemBuilder: (context, galleryPost, index) =>
                      const SizedBox(),
                ),
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '📸',
                    style: TextStyle(fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'まだ投稿がありません',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const PageHeader(
            title: '自分の投稿',
            color: CommonStyle.scaffoldBackgroundColor,
            showBackButton: true,
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
                    AccountGalleryPostsPageImageViewer(index: index),
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
