import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/common_style.dart';
import '../../../../utils/common_widgets/overlay_loading.dart';
import '../../../../utils/show_flushbar.dart';
import '../view_model.dart';

class AccountGalleryPostsPageImageViewer extends HookConsumerWidget {
  const AccountGalleryPostsPageImageViewer({required this.index});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(accountGalleryPostsPageViewModelProvider);
    final galleryPost = viewModel.pagingController.itemList?[index];

    if (galleryPost == null) {
      return const Scaffold(
        body: OverlayLoading(
          visible: true,
          child: SizedBox(),
        ),
      );
    }

    return Scaffold(
      key: viewModel.scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      endDrawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(top: 50),
          children: [
            ListTile(
              onTap: () {
                showFlushbar(
                  context,
                  message: '投稿のIDをコピーしました',
                );
                Clipboard.setData(ClipboardData(text: galleryPost.id));
              },
              leading: const Icon(Icons.copy),
              title: const Text('投稿のIDをコピー'),
            ),
            ListTile(
              onTap: () async {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
                // popの完了を待つ
                Timer(
                  const Duration(milliseconds: 500),
                  () => viewModel.deleteGalleryPost(index),
                );
              },
              leading: const Icon(Icons.delete_forever),
              title: const Text('投稿を削除'),
            ),
          ],
        ),
      ),
      backgroundColor: CommonStyle.transparent,
      body: Stack(
        children: [
          DismissiblePage(
            onDismissed: () => Navigator.of(context).pop(),
            isFullScreen: false,
            dragSensitivity: 1,
            maxTransformValue: 1,
            backgroundColor: CommonStyle.transparent,
            direction: DismissiblePageDismissDirection.multi,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: CachedNetworkImage(
                    imageUrl: galleryPost.imageUrls.first,
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
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                        color: CommonStyle.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 5,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                viewModel.scaffoldKey.currentState?.openEndDrawer();
              },
              child: Container(
                color: CommonStyle.transparent,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: const Icon(
                  Icons.menu,
                  size: 32,
                  color: CommonStyle.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
