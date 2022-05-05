import 'package:cloud_firestore/cloud_firestore.dart';

import '../product/product_model.dart';

class SignInRewardModel {
  SignInRewardModel({
    required this.id,
    required this.productId,
    required this.consumedPoint,
    required this.createdAt,
    required this.lastEditedAt,
    required this.product,
  });

  factory SignInRewardModel.fromDocumentSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
    required ProductModel product,
  }) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('DocumentSnapshot has no data.');
    }
    return SignInRewardModel(
      id: data['id'] as String,
      productId: data['product_id'] as String,
      consumedPoint: data['consumed_point'] as int,
      createdAt: data['created_at'] as Timestamp,
      lastEditedAt: data['last_edited_at'] as Timestamp,
      product: product,
    );
  }

  final String id;
  final String productId;
  final int consumedPoint;
  final Timestamp createdAt;
  final Timestamp lastEditedAt;

  final ProductModel product;
}
