import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/random_string.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import 'gallery_post_model.dart';

final favoriteGalleryPostRepositoryProvider =
    Provider<FavoriteGalleryPostRepository>(
  (ref) =>
      FavoriteGalleryPostRepository(ref.read(cloudFirestoreInterfaceProvider)),
);

class FavoriteGalleryPostRepository {
  const FavoriteGalleryPostRepository(
    this._cloudFirestoreInterface,
  );

  final CloudFirestoreInterface _cloudFirestoreInterface;

  Future<bool> isFavorite({
    required String accountId,
    required String galleryPostId,
  }) async {
    final querySnapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: favoriteGalleryPostsCollectionPath(galleryPostId),
      queryBuilder: (query) => query.where('account_id', isEqualTo: accountId),
    );
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addFavorite({
    required String accountId,
    required GalleryPostModel galleryPost,
  }) async {
    final id = randomString(20);
    await _cloudFirestoreInterface.addData(
      collectionPath: favoriteGalleryPostsCollectionPath(galleryPost.id),
      data: <String, dynamic>{
        'id': id,
        'account_id': accountId,
        'gallery_post_id': galleryPost.id,
        'gallery_post_product_id': galleryPost.productId,
        'gallery_post_account_id': galleryPost.accountId,
        'created_at': Timestamp.now(),
        'last_edited_at': Timestamp.now(),
      },
    );
  }

  Future<void> deleteFavorite({
    required String accountId,
    required String galleryPostId,
  }) async {
    final querySnapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: favoriteGalleryPostsCollectionPath(galleryPostId),
      queryBuilder: (query) => query.where('account_id', isEqualTo: accountId),
    );

    final docs = querySnapshot.docs;
    if (docs.isEmpty) {
      throw Exception('no favorite_gallery_posts document exists.');
    }

    await Future.wait<void>(docs.map((doc) => doc.reference.delete()));
  }
}
