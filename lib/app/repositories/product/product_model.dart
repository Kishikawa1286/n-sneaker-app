import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.adaptyPaywallId,
    required this.title,
    required this.vendor,
    required this.series,
    required this.tags,
    required this.titleJp,
    required this.vendorJp,
    required this.seriesJp,
    required this.tagsJp,
    required this.descriptionJp,
    required this.collectionProductStatementJp,
    required this.arStatementJp,
    required this.otherStatementJp,
    required this.imageUrls,
    required this.tileImageUrls,
    required this.transparentBackgroundImageUrls,
    required this.priceJpy,
    required this.numberOfFavorite,
    required this.numberOfHolders,
    required this.numberOfGlbFiles,
    required this.createdAt,
    required this.lastEditedAt,
    this.description,
    this.collectionProductStatement,
    this.arStatement,
    this.otherStatement,
    this.documentSnapshot,
  });

  factory ProductModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('DocumentSnapshot has no data.');
    }
    return ProductModel(
      id: data['id'] as String,
      adaptyPaywallId: (data['adapty_paywall_id'] as String?) ?? '',
      title: data['title'] as String,
      vendor: data['vendor'] as String,
      series: data['series'] as String,
      tags:
          List<String>.from(data['tags'] as List<dynamic>? ?? const <String>[]),
      description: data['description'] as String?,
      collectionProductStatement:
          data['collection_product_statement'] as String?,
      arStatement: data['ar_statement'] as String?,
      otherStatement: data['other_statement'] as String?,
      titleJp: data['title_jp'] as String,
      vendorJp: data['vendor_jp'] as String,
      seriesJp: data['series_jp'] as String,
      tagsJp: List<String>.from(data['tags_jp'] as List<dynamic>),
      descriptionJp: data['description_jp'] as String,
      collectionProductStatementJp:
          data['collection_product_statement_jp'] as String,
      arStatementJp: data['ar_statement_jp'] as String,
      otherStatementJp: data['other_statement_jp'] as String,
      imageUrls: List<String>.from(data['images'] as List<dynamic>),
      tileImageUrls: List<String>.from(data['tile_images'] as List<dynamic>),
      transparentBackgroundImageUrls: List<String>.from(
        data['transparent_background_images'] as List<dynamic>,
      ),
      priceJpy: data['price_jpy'] as int,
      numberOfFavorite: data['number_of_favorite'] as int,
      numberOfHolders: data['number_of_holders'] as int,
      numberOfGlbFiles: data['number_of_glb_files'] as int,
      createdAt: data['created_at'] as Timestamp,
      lastEditedAt: data['last_edited_at'] as Timestamp,
      documentSnapshot: snapshot,
    );
  }

  final String id;
  final String adaptyPaywallId;
  // product data
  final String title;
  final String vendor;
  final String series;
  // product data en
  final List<String> tags;
  final String? description;
  final String? collectionProductStatement;
  final String? arStatement;
  final String? otherStatement;
  // product data jp
  final String titleJp;
  final String vendorJp;
  final String seriesJp;
  final List<String> tagsJp;
  final String descriptionJp;
  final String collectionProductStatementJp;
  final String arStatementJp;
  final String otherStatementJp;
  // images
  final List<String> imageUrls;
  final List<String> tileImageUrls;
  final List<String> transparentBackgroundImageUrls;
  // count
  final int priceJpy;
  final int numberOfFavorite;
  final int numberOfHolders;
  final int numberOfGlbFiles;

  final Timestamp createdAt;
  final Timestamp lastEditedAt;

  final DocumentSnapshot? documentSnapshot;
}
