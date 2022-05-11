import 'gallery_post_model.dart';

class GalleryPostsFetchResult {
  const GalleryPostsFetchResult({
    required this.galleryPosts,
    required this.numberOfFetched,
    required this.numberOfBlocked,
    required this.numberOfInvalid,
  });

  final int numberOfFetched;
  final int numberOfBlocked;
  final int numberOfInvalid;

  final List<GalleryPostModel> galleryPosts;
}
