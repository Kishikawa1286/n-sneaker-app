import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../utils/common_style.dart';
import '../../../../utils/common_widgets/overlay_loading.dart';
import '../../../../utils/environment_variables.dart';
import '../../../../utils/show_flushbar.dart';
import '../../market_detail_page/market_detail_page.dart';
import '../view_model.dart';
import 'view_model.dart';

class GalleryImageViewer extends HookConsumerWidget {
  const GalleryImageViewer({required this.index});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryPageViewModel = ref.watch(galleryPageViewModelProvider);
    final galleryPost = galleryPageViewModel.pagingController.itemList?[index];

    if (galleryPost == null) {
      return const Scaffold(
        body: OverlayLoading(
          visible: true,
          child: SizedBox(),
        ),
      );
    }

    final galleryImageViewerViewModel =
        ref.watch(galleryImageViewerViewModelProvider(galleryPost.productId));
    final product = galleryImageViewerViewModel.product;

    if (product == null) {
      return const Scaffold(
        body: OverlayLoading(
          visible: true,
          child: SizedBox(),
        ),
      );
    }

    return Scaffold(
      key: galleryImageViewerViewModel.scaffoldKey,
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
                if (await canLaunchUrlString(galleryPostReportUrl)) {
                  await launchUrlString(galleryPostReportUrl);
                }
              },
              leading: const Icon(Icons.flag),
              title: const Text('悪質な投稿を報告'),
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
                  () => galleryPageViewModel.addBlockedAccountId(index),
                );
              },
              leading: const Icon(Icons.disabled_visible),
              title: const Text('同じユーザーの投稿を非表示'),
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
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: CachedNetworkImage(
                    imageUrl: galleryPost.imageUrls.first,
                    imageBuilder: (context, imageProvider) => Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(image: imageProvider),
                      ),
                    ),
                    placeholder: (_, __) => const SizedBox(),
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
                galleryImageViewerViewModel.scaffoldKey.currentState
                    ?.openEndDrawer();
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 5,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
              margin: const EdgeInsets.only(bottom: 40),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: ListTile(
                  tileColor: CommonStyle.transparent,
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: CachedNetworkImage(
                      imageUrl: product.tileImageUrls.first,
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
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          color: CommonStyle.grey,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    product.titleJp,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onTap: product.visibleInMarket
                      ? () =>
                          pushMarketDetailPage(context, productId: product.id)
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
