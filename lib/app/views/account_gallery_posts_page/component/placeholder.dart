import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../utils/common_style.dart';
import '../../../../utils/common_widgets/page_header.dart';
import '../../../repositories/gallery_post/gallery_post_model.dart';
import '../view_model.dart';

class AccountGalleryPostsPagePlaceholder extends HookConsumerWidget {
  const AccountGalleryPostsPagePlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(accountGalleryPostsPageViewModelProvider);
    final itemList = viewModel.pagingController.itemList;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const PageHeader(
                title: '自分の投稿',
                color: CommonStyle.scaffoldBackgroundColor,
                showBackButton: true,
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
          itemList == null
              ? Column(
                  children: [
                    Flexible(
                      child: PagedGridView<int, GalleryPostModel>(
                        pagingController: viewModel.pagingController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                        ),
                        builderDelegate:
                            PagedChildBuilderDelegate<GalleryPostModel>(
                          itemBuilder: (context, galleryPost, index) =>
                              const SizedBox(),
                          firstPageProgressIndicatorBuilder: (context) =>
                              const SizedBox(),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
