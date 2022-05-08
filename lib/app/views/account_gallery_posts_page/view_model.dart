import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/gallery_post/gallery_post_model.dart';
import '../../repositories/gallery_post/gallery_post_repository.dart';
import '../../services/account/account_service.dart';

final accountGalleryPostsPageViewModelProvider =
    AutoDisposeChangeNotifierProvider(
  (ref) => AccountGalleryPostsPageViewModel(
    ref.watch(accountServiceProvider),
    ref.read(galleryPostRepositoryProvider),
  ),
);

class AccountGalleryPostsPageViewModel extends ViewModelChangeNotifier {
  AccountGalleryPostsPageViewModel(
    this._accountService,
    this._galleryPostRepository,
  ) {
    _pagingController.addPageRequestListener(_fetch);
  }

  static const _limit = 32;

  final AccountService _accountService;
  final GalleryPostRepository _galleryPostRepository;

  final PagingController<int, GalleryPostModel> _pagingController =
      PagingController<int, GalleryPostModel>(firstPageKey: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PagingController<int, GalleryPostModel> get pagingController =>
      _pagingController;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  bool _loading = false;

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetch(int pageKey) async {
    final accountId = _accountService.account?.id;
    if (accountId == null) {
      return;
    }
    try {
      final startAfter = pagingController.itemList?.last;
      final fetched = await _galleryPostRepository.fetchByAccountId(
        accountId,
        limit: _limit,
        startAfter: startAfter,
      );
      // _pagingControllerのdispose後に操作をするのを回避
      if (disposed) {
        return;
      }
      if (fetched.length != _limit) {
        _pagingController.appendLastPage(fetched);
      } else {
        _pagingController.appendPage(fetched, pageKey + _limit);
      }
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      _pagingController.error = e;
    }
  }

  Future<bool> deleteGalleryPost(int index) async {
    if (_loading) {
      return false;
    }
    final galleryPost = _pagingController.itemList?[index];
    if (galleryPost == null) {
      return false;
    }
    try {
      _loading = true;
      notifyListeners();
      await _galleryPostRepository.deleteGalleryPost(galleryPost);
      _loading = false;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}
