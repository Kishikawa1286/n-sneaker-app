import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/view_model_change_notifier.dart';
import '../../../repositories/gallery_post/favorite_gallery_post_repository.dart';
import '../../../repositories/gallery_post/gallery_post_model.dart';
import '../../../repositories/gallery_post/gallery_post_repository.dart';
import '../../../repositories/product/product_model.dart';
import '../../../repositories/product/product_repository.dart';
import '../../../services/account/account_service.dart';

final galleryImageViewerViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<GalleryImageViewerViewModel,
        String>(
  (ref, galleryPostId) => GalleryImageViewerViewModel(
    galleryPostId,
    ref.read(productRepositoryProvider),
    ref.read(galleryPostRepositoryProvider),
    ref.read(favoriteGalleryPostRepositoryProvider),
    ref.watch(accountServiceProvider),
  ),
);

class GalleryImageViewerViewModel extends ViewModelChangeNotifier {
  GalleryImageViewerViewModel(
    this._galleryPostId,
    this._productRepository,
    this._galleryPostRepository,
    this._favoriteGalleryPostRepository,
    this._accountService,
  ) {
    _init();
  }

  final String _galleryPostId;

  final ProductRepository _productRepository;
  final GalleryPostRepository _galleryPostRepository;
  final FavoriteGalleryPostRepository _favoriteGalleryPostRepository;
  final AccountService _accountService;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  GalleryPostModel? _galleryPost;
  ProductModel? _product;
  bool? _isFavoriteOriginal;
  bool? _isFavorite;
  bool _loading = false;

  GalleryPostModel? get galleryPost => _galleryPost;
  ProductModel? get product => _product;
  bool? get isFavorite => _isFavorite;
  int get numberOfFavorite {
    final gp = _galleryPost;
    final isf = _isFavorite;
    final isfo = _isFavoriteOriginal;
    if (gp == null || isf == null || isfo == null) {
      return 0;
    }

    if (isf == isfo) {
      return gp.numberOfFavorites;
    }

    if (isf) {
      return gp.numberOfFavorites + 1;
    }
    return gp.numberOfFavorites - 1;
  }

  Future<void> _init() async {
    try {
      final ac = _accountService.account;
      if (ac == null) {
        return;
      }

      final gp = await _galleryPostRepository.fetchById(_galleryPostId);
      _galleryPost = gp;
      _product = await _productRepository.fetchProductById(gp.productId);
      _isFavorite = await _favoriteGalleryPostRepository.isFavorite(
        accountId: ac.id,
        galleryPostId: _galleryPostId,
      );
      _isFavoriteOriginal = _isFavorite;
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  void toggleFavorite() {
    final isf = _isFavorite;
    if (isf == null) {
      return;
    }
    if (isf) {
      _isFavorite = false;
    } else {
      _isFavorite = true;
    }
    notifyListeners();
  }

  Future<void> addBlockedAccountId() async {
    if (_loading) {
      return;
    }

    final gp = _galleryPost;
    if (gp == null) {
      return;
    }

    try {
      _loading = true;
      await _galleryPostRepository.addBlockedAccountId(gp.accountId);
      _loading = false;
      notifyListeners();
      return;
    } on Exception catch (e) {
      print(e);
      _loading = false;
      return;
    }
  }

  Future<void> onPop() async {
    if (_loading) {
      return;
    }

    final isf = _isFavorite;
    final isfo = _isFavoriteOriginal;
    if (isf == null || isfo == null) {
      return;
    }

    // いいねの状態に変化なし
    if (isf == isfo) {
      return;
    }

    try {
      _loading = true;
      // リモートに反映
      if (isf) {
        await _addFavorite();
      } else {
        await _deleteFavorite();
      }
      _loading = false;
      notifyListeners();
      return;
    } on Exception catch (e) {
      print(e);
      _loading = false;
      return;
    }
  }

  Future<void> _addFavorite() async {
    if (_isFavoriteOriginal ?? true) {
      return;
    }
    final ac = _accountService.account;
    if (ac == null) {
      return;
    }
    final gp = _galleryPost;
    if (gp == null) {
      return;
    }

    try {
      await _favoriteGalleryPostRepository.addFavorite(
        accountId: ac.id,
        galleryPost: gp,
      );
      return;
    } on Exception catch (e) {
      print(e);
      return;
    }
  }

  Future<void> _deleteFavorite() async {
    if (!(_isFavoriteOriginal ?? true)) {
      return;
    }
    final ac = _accountService.account;
    if (ac == null) {
      return;
    }

    try {
      await _favoriteGalleryPostRepository.deleteFavorite(
        accountId: ac.id,
        galleryPostId: _galleryPostId,
      );
      return;
    } on Exception catch (e) {
      print(e);
      return;
    }
  }
}
