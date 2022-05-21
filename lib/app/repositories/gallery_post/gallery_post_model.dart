import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryPostModel {
  const GalleryPostModel({
    required this.id,
    required this.productId,
    required this.accountId,
    required this.imageUrls,
    required this.imageStoragePaths,
    required this.compressedImageUrls,
    required this.compressedImageStoragePaths,
    required this.numberOfFavorites,
    required this.createdAt,
    required this.lastEditedAt,
    this.documentSnapshot,
  });

  factory GalleryPostModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('DocumentSnapshot has no data.');
    }
    final imageUrls = List<String>.from(data['image_urls'] as List<dynamic>);
    final imageStoragePaths =
        List<String>.from(data['image_storage_paths'] as List<dynamic>);
    final compressedImageUrls =
        List<String>.from(data['compressed_image_urls'] as List<dynamic>);
    final compressedImageStoragePaths = List<String>.from(
      data['compressed_image_storage_paths'] as List<dynamic>,
    );
    if (imageUrls.length != imageStoragePaths.length) {
      throw Exception(
        'imageUrls.length != imageStoragePaths.length',
      );
    }
    if (imageUrls.length != compressedImageUrls.length) {
      throw Exception(
        'imageUrls.length != compressedImageUrls.length',
      );
    }
    if (imageUrls.length != compressedImageStoragePaths.length) {
      throw Exception(
        'imageUrls.length != compressedImageStoragePaths.length',
      );
    }
    return GalleryPostModel(
      id: data['id'] as String,
      productId: data['product_id'] as String,
      accountId: data['account_id'] as String,
      imageUrls: imageUrls,
      imageStoragePaths: imageStoragePaths,
      compressedImageUrls: compressedImageUrls,
      compressedImageStoragePaths: compressedImageStoragePaths,
      numberOfFavorites: data['number_of_favorites'] as int,
      createdAt: data['created_at'] as Timestamp,
      lastEditedAt: data['last_edited_at'] as Timestamp,
      documentSnapshot: snapshot,
    );
  }

  final String id;
  final String productId;
  final String accountId;
  final List<String> imageUrls;
  final List<String> imageStoragePaths;
  final List<String> compressedImageUrls;
  final List<String> compressedImageStoragePaths;
  final int numberOfFavorites;
  final Timestamp createdAt;
  final Timestamp lastEditedAt;
  final DocumentSnapshot? documentSnapshot;
}
