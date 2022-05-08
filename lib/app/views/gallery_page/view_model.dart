import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/gallery_post/gallery_post_model.dart';
import '../../repositories/gallery_post/gallery_post_repository.dart';

final galleryPageViewModelProvider = AutoDisposeChangeNotifierProvider(
  (ref) => GalleryPageViewModel(
    ref.read(galleryPostRepositoryProvider),
  ),
);

class GalleryPageViewModel extends ViewModelChangeNotifier {
  GalleryPageViewModel(
    this._galleryPostRepository,
  ) {
    _pagingController.addPageRequestListener(_fetch);
  }

  static const _limit = 32;

  final GalleryPostRepository _galleryPostRepository;

  final PagingController<int, GalleryPostModel> _pagingController =
      PagingController<int, GalleryPostModel>(firstPageKey: 0);

  PagingController<int, GalleryPostModel> get pagingController =>
      _pagingController;

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetch(int pageKey) async {
    try {
      final startAfter = pagingController.itemList?.last;
      final fetched = await _galleryPostRepository.fetchNew(
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
}
