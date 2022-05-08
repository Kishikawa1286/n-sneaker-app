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

  Future<List<GalleryPostModel>> fetchByAccountId(
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
      return _convertDocumentSnapshotListToGalleryPostModelList(snapshot.docs);
    }
    final startAfterDocumentSnapshot = startAfter.documentSnapshot;
    if (startAfterDocumentSnapshot == null) {
      return [];
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
    return _convertDocumentSnapshotListToGalleryPostModelList(snapshot.docs);
  }

  Future<List<GalleryPostModel>> fetchNew({
    int limit = 16,
    GalleryPostModel? startAfter,
  }) async {
    // where-inに入れられない空配列を回避
    final blockedAccountIds = [...await _getBlockedAccountIds(), ''];
    if (startAfter == null) {
      // startAfterを指定しない
      final snapshot =
          await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
        collectionPath: galleryPostsCollectionPath,
        // see: https://stackoverflow.com/questions/66829643/cloud-firestore-inequality-operator-exception-flutter
        queryBuilder: (query) => query
            .where('account_id', whereNotIn: blockedAccountIds)
            .orderBy('account_id')
            .orderBy('created_at', descending: true)
            .limit(limit),
      );
      return _convertDocumentSnapshotListToGalleryPostModelList(snapshot.docs);
    }
    final startAfterDocumentSnapshot = startAfter.documentSnapshot;
    if (startAfterDocumentSnapshot == null) {
      return [];
    }
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: galleryPostsCollectionPath,
      queryBuilder: (query) => query
          .where('account_id', whereNotIn: blockedAccountIds)
          .orderBy('account_id')
          .orderBy('created_at', descending: true)
          .limit(limit)
          .startAfterDocument(startAfterDocumentSnapshot),
    );
    return _convertDocumentSnapshotListToGalleryPostModelList(snapshot.docs);
  }

  List<GalleryPostModel> _convertDocumentSnapshotListToGalleryPostModelList(
    List<DocumentSnapshot<Map<String, dynamic>>> docs,
  ) =>
      docs
          .map((documentSnapshot) {
            try {
              return GalleryPostModel.fromDocumentSnapshot(documentSnapshot);
            } on Exception catch (e) {
              print(e);
              return null;
            }
          })
          .toList()
          .whereType<GalleryPostModel>()
          .toList();

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
    await _cloudFirestoreInterface.addData(
      collectionPath: galleryPostsCollectionPath,
      data: <String, dynamic>{
        'id': id,
        'product_id': productId,
        'account_id': accountId,
        'image_urls': [imageUrl],
        'image_storage_paths': [imageStoragePath],
        'compressed_image_urls': [compressedImageUrl],
        'compressed_image_storage_paths': [compressedImageStoragePath],
        'created_at': Timestamp.now(),
        'last_edited_at': Timestamp.now(),
      },
    );
  }

  Future<void> deleteGalleryPost(GalleryPostModel galleryPost) async {
    await _cloudFirestoreInterface.deleteData(
      documentPath: galleryPostDocumentPath(galleryPost.id),
    );
    await Future.wait(
      galleryPost.imageStoragePaths.map(
        (path) => _firebaseStorageInterface.deleteDirectory(path: path),
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
