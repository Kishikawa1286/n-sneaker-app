import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  const AccountModel({
    required this.id,
    required this.numberOfCollectionProducts,
    required this.createdAt,
    required this.lastEditedAt,
    required this.point,
    required this.lastSignedInAt,
  });

  factory AccountModel.fromDocumentSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
  }) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('DocumentSnapshot has no data.');
    }
    return AccountModel(
      id: data['id'] as String,
      numberOfCollectionProducts:
          int.tryParse(data['number_of_collection_products'].toString()) ?? 0,
      createdAt: data['created_at'] as Timestamp,
      lastEditedAt: data['last_edited_at'] as Timestamp,
      point: (data['point'] as int?) ?? 0,
      lastSignedInAt:
          (data['last_signed_in_at'] as Timestamp?) ?? Timestamp.now(),
    );
  }

  final String id;
  final int numberOfCollectionProducts;
  final Timestamp createdAt;
  final Timestamp lastEditedAt;
  final int point;
  final Timestamp lastSignedInAt;
}
