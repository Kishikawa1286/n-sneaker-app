import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/models/transaction.dart'
    as revenuecat_transaction;

import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import '../../interfaces/firebase/cloud_functions/add_collection_product_on_making_purchase_parameters.dart';
import '../../interfaces/firebase/cloud_functions/add_collection_product_on_restoring_purchase_parameters.dart';
import '../../interfaces/firebase/cloud_functions/cloud_functions_interface.dart';
import '../product/product_model.dart';
import 'collection_product_model.dart';

final collectionProductRepositoryProvider =
    Provider<CollectionProductRepository>(
  (ref) => CollectionProductRepository(
    ref.read(cloudFirestoreInterfaceProvider),
    ref.read(cloudFunctionsInterfaceProvider),
  ),
);

class CollectionProductRepository {
  const CollectionProductRepository(
    this._cloudFirestoreInterface,
    this._cloudFunctionsInterface,
  );

  final CloudFirestoreInterface _cloudFirestoreInterface;
  final CloudFunctionsInterface _cloudFunctionsInterface;

  List<CollectionProductModel>
      _convertDocumentSnapshotListToCollectionProductModelList(
    List<DocumentSnapshot<Map<String, dynamic>>> docs,
  ) =>
          docs
              .map((documentSnapshot) {
                try {
                  return CollectionProductModel.fromDocumentSnapshot(
                    documentSnapshot,
                  );
                } on Exception catch (e) {
                  print(e);
                  return null;
                }
              })
              .toList()
              .whereType<CollectionProductModel>()
              .toList();

  Future<bool> checkIfPurchased({
    required String accountId,
    required String productId,
  }) async {
    final querySnapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: collectionProductsCollectionPath,
      queryBuilder: (query) => query
          .where('account_id', isEqualTo: accountId)
          .where('product_id', isEqualTo: productId)
          .limit(1),
    );
    final docs = querySnapshot.docs;
    if (docs.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> addCollectionProductOnMakingPurchase({
    required ProductModel product,
    required revenuecat_transaction.Transaction transaction,
  }) async {
    final params = AddCollectionProductOnMakingPurchaseParameters(
      productId: product.id,
      revenuecatTransactionId: transaction.revenueCatId,
    );
    final result = await _cloudFunctionsInterface
        .addCollectionProductOnMakingPurchase(params);
    if (result.data.toString().contains('Error')) {
      throw Exception('No purchase was found.');
    }
  }

  Future<void> addCollectionProductOnRestoringPurchase(String productId) async {
    final params =
        AddCollectionProductOnRestoringPurchaseParameters(productId: productId);
    final result = await _cloudFunctionsInterface
        .addCollectionProductOnRestoringPurchase(params);
    if (result.data.toString().contains('Error')) {
      throw Exception('No purchase was found.');
    }
  }

  Future<void> addCollectionProductOnSignInReward() =>
      _cloudFunctionsInterface.addCollectionProductOnSignInReward();

  Future<List<CollectionProductModel>> fetchCollectionProductsFromFirestore(
    String accountId, {
    int limit = 16,
    CollectionProductModel? startAfter,
  }) async {
    if (startAfter == null) {
      // startAfterを指定しない
      final snapshot =
          await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
        collectionPath: collectionProductsCollectionPath,
        queryBuilder: (query) => query
            .where('account_id', isEqualTo: accountId)
            .orderBy('created_at', descending: true)
            .limit(limit),
      );
      return _convertDocumentSnapshotListToCollectionProductModelList(
        snapshot.docs,
      );
    }
    final startAfterDocumentSnapshot = startAfter.documentSnapshot;
    // 通常 not null だが nullble を解除するためにチェック
    if (startAfterDocumentSnapshot == null) {
      return [];
    }
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: collectionProductsCollectionPath,
      queryBuilder: (query) => query
          .where('account_id', isEqualTo: accountId)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .startAfterDocument(startAfterDocumentSnapshot),
    );
    return _convertDocumentSnapshotListToCollectionProductModelList(
      snapshot.docs,
    );
  }

  List<CollectionProductModel> convertProductsToCollectionProducts(
    List<ProductModel> products,
  ) =>
      products.map(CollectionProductModel.fromProduct).toList();
}
