import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/random_string.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import '../../interfaces/firebase/firebase_storage/content_type.dart';
import '../../interfaces/firebase/firebase_storage/firebase_storage_interface.dart';
import '../../interfaces/firebase/firebase_storage/firebase_storage_paths.dart';
import '../../interfaces/shared_preferences/shared_preferences_interface.dart';
import '../../interfaces/shared_preferences/shared_preferences_key.dart';
import 'gallery_post_model.dart';
import 'gallery_posts_fech_result.dart';

final galleryPostRepositoryProvider = Provider<GalleryPostRepository>(
  (ref) => GalleryPostRepository(
    ref.read(cloudFirestoreInterfaceProvider),
    ref.read(firebaseStorageInterface),
    ref.read(sharedPreferencesInterfaceProvider),
  ),
);

class GalleryPostRepository {
  const GalleryPostRepository(
    this._cloudFirestoreInterface,
    this._firebaseStorageInterface,
    this._sharedPreferencesInterface,
  );

  final CloudFirestoreInterface _cloudFirestoreInterface;
  final FirebaseStorageInterface _firebaseStorageInterface;
  final SharedPreferencesInterface _sharedPreferencesInterface;

  Future<GalleryPostModel> fetchById(String id) async {
    final snapshot = await _cloudFirestoreInterface.fetchDocumentSnapshot(
      documentPath: galleryPostDocumentPath(id),
    );
    return GalleryPostModel.fromDocumentSnapshot(snapshot);
  }

  Future<GalleryPostsFetchResult> fetchByAccountId(
    String accountId, {
    int limit = 16,
    GalleryPostModel? startAfter,
  }) async {
    if (startAfter == null) {
      // startAfterを指定しない
      final snapshot =
          await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
        collectionPath: galleryPostsCollectionPath,
        queryBuilder: (query) => query
            .where('account_id', isEqualTo: accountId)
            .orderBy('created_at', descending: true)
            .limit(limit),
      );
      return _processDocumentSnapshotList(snapshot.docs);
    }
    final startAfterDocumentSnapshot = startAfter.documentSnapshot;
    if (startAfterDocumentSnapshot == null) {
      throw Exception('startAfter.documentSnapshot is null.');
    }
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: galleryPostsCollectionPath,
      queryBuilder: (query) => query
          .where('account_id', isEqualTo: accountId)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .startAfterDocument(startAfterDocumentSnapshot),
    );
    return _processDocumentSnapshotList(snapshot.docs);
  }

  Future<GalleryPostsFetchResult> fetchNew({
    int limit = 16,
    GalleryPostModel? startAfter,
  }) async {
    // where-inに入れられない空配列を回避
    final blockedAccountIds = await _getBlockedAccountIds();
    if (startAfter == null) {
      // startAfterを指定しない
      final snapshot =
          await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
        collectionPath: galleryPostsCollectionPath,
        queryBuilder: (query) =>
            query.orderBy('created_at', descending: true).limit(limit),
      );
      return _processDocumentSnapshotList(
        snapshot.docs,
        blockedAccountIds: blockedAccountIds,
      );
    }
    final startAfterDocumentSnapshot = startAfter.documentSnapshot;
    if (startAfterDocumentSnapshot == null) {
      throw Exception('startAfter.documentSnapshot is null.');
    }
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: galleryPostsCollectionPath,
      queryBuilder: (query) => query
          .orderBy('created_at', descending: true)
          .limit(limit)
          .startAfterDocument(startAfterDocumentSnapshot),
    );
    return _processDocumentSnapshotList(
      snapshot.docs,
      blockedAccountIds: blockedAccountIds,
    );
  }

  GalleryPostsFetchResult _processDocumentSnapshotList(
    List<DocumentSnapshot<Map<String, dynamic>>> docs, {
    List<String> blockedAccountIds = const <String>[],
  }) {
    final numberOfFetched = docs.length;
    final rawGalleryPosts = docs
        .map((doc) {
          try {
            return GalleryPostModel.fromDocumentSnapshot(doc);
          } on Exception catch (e) {
            print(e);
            return null;
          }
        })
        .toList()
        .whereType<GalleryPostModel>()
        .toList();
    final numberOfInvalid = numberOfFetched - rawGalleryPosts.length;
    final galleryPosts = rawGalleryPosts
        .where(
          (galleryPost) => !blockedAccountIds.contains(galleryPost.accountId),
        )
        .toList();
    final numberOfBlocked =
        numberOfFetched - numberOfInvalid - galleryPosts.length;
    return GalleryPostsFetchResult(
      numberOfFetched: numberOfFetched,
      numberOfInvalid: numberOfInvalid,
      numberOfBlocked: numberOfBlocked,
      galleryPosts: galleryPosts,
    );
  }

  Future<void> addGalleryPost({
    required String accountId,
    required String productId,
    required MemoryImage image,
  }) async {
    final id = randomString(20);
    final fileName = '${randomString(20)}.png'; // Unity側でpngとして保存している
    final imageStoragePath = galleryPostImagePath(accountId, id, fileName);
    final imageUrl = await _firebaseStorageInterface.uploadFile(
      path: imageStoragePath,
      bytes: image.bytes,
      contentType: ContentType.png,
    );
    final compressedBytes = await FlutterImageCompress.compressWithList(
      image.bytes,
      quality: 50,
    );
    final compressedFileName = '${randomString(20)}.png'; // Unity側でpngとして保存している
    final compressedImageStoragePath =
        galleryPostImagePath(accountId, id, compressedFileName);
    final compressedImageUrl = await _firebaseStorageInterface.uploadFile(
      path: compressedImageStoragePath,
      bytes: compressedBytes,
      contentType: ContentType.png,
    );
    final collectionReference = _cloudFirestoreInterface.collectionReference(
      collectionPath: galleryPostsCollectionPath,
    );
    final documentReference = collectionReference.doc(id);
    await documentReference.set(<String, dynamic>{
      'id': id,
      'product_id': productId,
      'account_id': accountId,
      'image_urls': [imageUrl],
      'image_storage_paths': [imageStoragePath],
      'compressed_image_urls': [compressedImageUrl],
      'compressed_image_storage_paths': [compressedImageStoragePath],
      'created_at': Timestamp.now(),
      'last_edited_at': Timestamp.now(),
    });
  }

  Future<void> deleteGalleryPost(GalleryPostModel galleryPost) async {
    await _cloudFirestoreInterface.deleteData(
      documentPath: galleryPostDocumentPath(galleryPost.id),
    );
    await Future.wait(
      galleryPost.imageStoragePaths.map(
        (path) => _firebaseStorageInterface.deleteFile(path: path),
      ),
    );
    await Future.wait(
      galleryPost.compressedImageStoragePaths.map(
        (path) => _firebaseStorageInterface.deleteFile(path: path),
      ),
    );
  }

  Future<List<String>> _getBlockedAccountIds() async =>
      await _sharedPreferencesInterface
          .getStringList(SharedPreferencesKey.blockedAccountIds) ??
      [];

  Future<void> addBlockedAccountId(String accountId) async {
    const key = SharedPreferencesKey.blockedAccountIds;
    await _sharedPreferencesInterface.setStringList(
      key: key,
      value: [...await _getBlockedAccountIds(), accountId],
    );
  }

  Future<void> clearBlockedAccountIds() => _sharedPreferencesInterface
      .remove(SharedPreferencesKey.blockedAccountIds);
}
