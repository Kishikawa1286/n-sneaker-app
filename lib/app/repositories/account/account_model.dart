import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  const AccountModel({
    required this.id,
    required this.numberOfCollectionProducts,
    required this.createdAt,
    required this.lastEditedAt,
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
    );
  }

  final String id;
  final int numberOfCollectionProducts;
  final Timestamp createdAt;
  final Timestamp lastEditedAt;
}
