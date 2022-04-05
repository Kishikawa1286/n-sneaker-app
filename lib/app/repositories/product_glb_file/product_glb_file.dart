import 'package:cloud_firestore/cloud_firestore.dart';

class ProductGlbFileModel {
  const ProductGlbFileModel({
    required this.availableForAr,
    required this.availableForViewer,
    required this.id,
    required this.filePath,
    required this.fileExists,
    required this.title,
    required this.titleJp,
    required this.imageUrls,
    required this.createdAt,
    required this.lastEditedAt,
    required this.productId,
    required this.productTitle,
    required this.productVendor,
    required this.productSeries,
    required this.productTags,
    required this.productTitleJp,
    required this.productVendorJp,
    required this.productSeriesJp,
    required this.productTagsJp,
    this.documentSnapshot,
  });

  factory ProductGlbFileModel.fromDocumentSnapshotAndFileData({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
    required String filePath,
    required bool fileExists,
  }) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('DocumentSnapshot has no data.');
    }
    return ProductGlbFileModel(
      availableForViewer: data['available_for_viewer'] as bool,
      availableForAr: data['available_for_ar'] as bool,
      id: data['id'] as String,
      filePath: filePath,
      fileExists: fileExists,
      title: data['title'] as String,
      titleJp: data['title_jp'] as String,
      imageUrls: List<String>.from(data['images'] as List<dynamic>),
      createdAt: data['created_at'] as Timestamp,
      lastEditedAt: data['last_edited_at'] as Timestamp,
      productId: data['product_id'] as String,
      productTitle: data['product_title'] as String,
      productVendor: data['product_vendor'] as String,
      productSeries: data['product_series'] as String,
      productTags: List<String>.from(data['product_tags'] as List<dynamic>),
      productTitleJp: data['product_title_jp'] as String,
      productVendorJp: data['product_vendor_jp'] as String,
      productSeriesJp: data['product_series_jp'] as String,
      productTagsJp:
          List<String>.from(data['product_tags_jp'] as List<dynamic>),
      documentSnapshot: snapshot,
    );
  }

  final bool availableForViewer;
  final bool availableForAr;

  final String id;

  final String filePath;
  final bool fileExists;

  final String title;
  final String titleJp;

  final List<String> imageUrls;

  final Timestamp createdAt;
  final Timestamp lastEditedAt;

  // product data
  final String productId;

  final String productTitle;
  final String productVendor;
  final String productSeries;
  // product data en
  final List<String> productTags;
  // product data jp
  final String productTitleJp;
  final String productVendorJp;
  final String productSeriesJp;
  final List<String> productTagsJp;

  final DocumentSnapshot? documentSnapshot;
}
