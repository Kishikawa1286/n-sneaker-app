import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import 'product_model.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(ref.read(cloudFirestoreInterfaceProvider)),
);

class ProductRepository {
  const ProductRepository(this._cloudFirestoreInterface);

  final CloudFirestoreInterface _cloudFirestoreInterface;

  List<ProductModel> _convertDocumentSnapshotListToProductModelList(
    List<DocumentSnapshot<Map<String, dynamic>>> docs,
  ) =>
      docs
          .map((documentSnapshot) {
            try {
              return ProductModel.fromDocumentSnapshot(documentSnapshot);
            } on Exception catch (e) {
              print(e);
              return null;
            }
          })
          .toList()
          .whereType<ProductModel>()
          .toList();

  Future<ProductModel> fetchProductById(String id) async {
    final snapshot = await _cloudFirestoreInterface.fetchDocumentSnapshot(
      documentPath: productDocumentPath(id),
    );
    return ProductModel.fromDocumentSnapshot(snapshot);
  }

  Future<List<ProductModel>> fetchProducts({
    int limit = 16,
    ProductModel? startAfter,
  }) async {
    if (startAfter == null) {
      // startAfterを指定しない
      final snapshot =
          await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
        collectionPath: productsCollectionPath,
        queryBuilder: (query) => query
            .where('vivsible_in_market', isEqualTo: true)
            .orderBy('created_at', descending: true)
            .limit(limit),
      );
      return _convertDocumentSnapshotListToProductModelList(snapshot.docs);
    }
    final startAfterDocumentSnapshot = startAfter.documentSnapshot;
    if (startAfterDocumentSnapshot == null) {
      return [];
    }
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: productsCollectionPath,
      queryBuilder: (query) => query
          .where('vivsible_in_market', isEqualTo: true)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .startAfterDocument(startAfterDocumentSnapshot),
    );
    return _convertDocumentSnapshotListToProductModelList(snapshot.docs);
  }

  Future<List<ProductModel>> fetchProductsBySeriesJp(
    String seriesJp, {
    int limit = 16,
    ProductModel? startAfter,
  }) async {
    if (startAfter == null) {
      // startAfterを指定しない
      final snapshot =
          await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
        collectionPath: productsCollectionPath,
        queryBuilder: (query) => query
            .where('vivsible_in_market', isEqualTo: true)
            .where('series_jp', isEqualTo: seriesJp)
            .orderBy('created_at', descending: true)
            .limit(limit),
      );
      return _convertDocumentSnapshotListToProductModelList(snapshot.docs);
    }
    final startAfterDocumentSnapshot = startAfter.documentSnapshot;
    if (startAfterDocumentSnapshot == null) {
      return [];
    }
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: productsCollectionPath,
      queryBuilder: (query) => query
          .where('vivsible_in_market', isEqualTo: true)
          .where('series_jp', isEqualTo: seriesJp)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .startAfterDocument(startAfterDocumentSnapshot),
    );
    return _convertDocumentSnapshotListToProductModelList(snapshot.docs);
  }
}
