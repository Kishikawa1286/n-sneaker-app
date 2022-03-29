import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final Provider<CloudFirestoreInterface> cloudFirestoreInterfaceProvider =
    Provider<CloudFirestoreInterface>((ref) => CloudFirestoreInterface());

class CloudFirestoreInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setData({
    required String documentPath,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    final reference = _firestore.doc(documentPath);
    print('$documentPath: $data');
    await reference.set(data, SetOptions(merge: merge));
  }

  Future<DocumentReference<Map<String, dynamic>>> addData({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    final reference = _firestore.collection(collectionPath);
    return reference.add(data);
  }

  Future<void> updateArrayElement({
    required String documentPath,
    required Map<String, dynamic> data,
    required String fieldName,
  }) async {
    final reference = _firestore.doc(documentPath);
    print('$documentPath: $data');
    await reference.update(<String, dynamic>{
      fieldName: FieldValue.arrayUnion(<dynamic>[data])
    });
  }

  Future<void> removeArrayElement({
    required String documentPath,
    required Map<String, dynamic> data,
    required String fieldName,
  }) async {
    final reference = _firestore.doc(documentPath);
    print('$documentPath: $data');
    await reference.update(<String, dynamic>{
      fieldName: FieldValue.arrayRemove(<dynamic>[data])
    });
  }

  Future<void> updateData({
    required String documentPath,
    required Map<String, dynamic> data,
  }) async {
    final reference = _firestore.doc(documentPath);
    print('$documentPath: $data');
    await reference.update(data);
  }

  Future<void> deleteData({required String documentPath}) async {
    final reference = _firestore.doc(documentPath);
    print('delete: $documentPath');
    await reference.delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> collectionStream({
    required String collectionPath,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> collectionFuture<T>({
    required String collectionPath,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream({
    required String documentPath,
  }) {
    final reference = _firestore.doc(documentPath);
    return reference.snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchDocumentSnapshot({
    required String documentPath,
  }) {
    final reference = _firestore.doc(documentPath);
    return reference.get();
  }
}
