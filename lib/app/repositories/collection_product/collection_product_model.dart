import 'package:cloud_firestore/cloud_firestore.dart';

import '../product/product_model.dart';

class CollectionProductModel {
  const CollectionProductModel({
    required this.id,
    required this.accountId,
    required this.paymentMethod,
    required this.vendorProductId,
    required this.purchasedAtAsIso8601,
    required this.isTrial,
    required this.createdAt,
    required this.lastEditedAt,
    required this.productId,
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
    this.description,
    this.collectionProductStatement,
    this.arStatement,
    this.otherStatement,
    this.documentSnapshot,
  });

  factory CollectionProductModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('DocumentSnapshot has no data.');
    }
    return CollectionProductModel(
      id: data['id'] as String,
      accountId: data['account_id'] as String,
      paymentMethod: data['payment_method'] as String,
      vendorProductId: data['vendor_product_id'] as String,
      purchasedAtAsIso8601: data['purchased_at'] as String,
      isTrial: false,
      createdAt: data['created_at'] as Timestamp,
      lastEditedAt: data['last_edited_at'] as Timestamp,
      productId: data['product_id'] as String,
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
      documentSnapshot: snapshot,
    );
  }

  factory CollectionProductModel.fromProduct(ProductModel product) =>
      CollectionProductModel(
        id: '',
        accountId: '',
        paymentMethod: '',
        vendorProductId: '',
        purchasedAtAsIso8601: '',
        isTrial: true,
        createdAt: Timestamp.now(),
        lastEditedAt: Timestamp.now(),
        productId: product.id,
        title: product.title,
        vendor: product.vendor,
        series: product.series,
        tags: product.tags,
        titleJp: product.titleJp,
        vendorJp: product.vendorJp,
        seriesJp: product.seriesJp,
        tagsJp: product.tagsJp,
        descriptionJp: product.descriptionJp,
        collectionProductStatementJp: product.collectionProductStatementJp,
        arStatementJp: product.arStatementJp,
        otherStatementJp: product.otherStatementJp,
        imageUrls: product.imageUrls,
        tileImageUrls: product.tileImageUrls,
        transparentBackgroundImageUrls: product.transparentBackgroundImageUrls,
      );

  final String id;

  final String accountId;
  final String paymentMethod;
  final String vendorProductId;
  final String purchasedAtAsIso8601;

  final bool isTrial;

  final Timestamp createdAt;
  final Timestamp lastEditedAt;

  // product data
  final String productId;

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
  final DocumentSnapshot? documentSnapshot;
}
