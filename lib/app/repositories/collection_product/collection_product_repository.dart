import 'package:adapty_flutter/results/make_purchase_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/convert_paywall_id_to_vendor_product_id.dart';
import '../../../utils/enum_to_string.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import '../../interfaces/firebase/cloud_functions/add_collection_product_on_making_purchase_parameters.dart';
import '../../interfaces/firebase/cloud_functions/add_collection_product_on_restoring_purchase_parameters.dart';
import '../../interfaces/firebase/cloud_functions/cloud_functions_interface.dart';
import '../product/product_model.dart';
import 'collection_product_model.dart';
import 'payment_method.dart';

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
    required MakePurchaseResult makePurchaseResult,
  }) async {
    final paywallId = product.adaptyPaywallId;
    final vendorProductId = convertPaywallIdToVendorProductId(paywallId);
    if (vendorProductId.isEmpty) {
      throw Exception('generating vendor product id failed.');
    }
    final nonSubscriptions =
        makePurchaseResult.purchaserInfo?.nonSubscriptions[vendorProductId];
    if (nonSubscriptions == null) {
      throw Exception('no nonSubscription for id $vendorProductId exists.');
    }
    final purchasedAtList = nonSubscriptions
        .map((nonSubscription) => nonSubscription.purchasedAt)
        .whereType<DateTime>()
        .toList();
    // lastを呼び出すのでEmptyチェック
    if (purchasedAtList.isEmpty) {
      throw Exception('no nonSubscription for id $vendorProductId exists.');
    }
    // 時系列順にソートされる（最新のものが最後）
    purchasedAtList.sort((a, b) => a.compareTo(b));
    final purchasedAt = purchasedAtList.last;
    final params = AddCollectionProductOnMakingPurchaseParameters(
      productId: product.id,
      paymentMethod: enumToString(generatePaymentMethodFromDevice()),
      purchasedAtAsIso8601: purchasedAt.toIso8601String(),
      vendorProductId: vendorProductId,
    );
    final result = await _cloudFunctionsInterface
        .addCollectionProductOnMakingPurchase(params);
    print(result.data);
  }

  Future<void> addCollectionProductOnRestoringPurchase(
    String productId,
  ) async {
    final params =
        AddCollectionProductOnRestoringPurchaseParameters(productId: productId);
    final result = await _cloudFunctionsInterface
        .addCollectionProductOnRestoringPurchase(params);
    print(result.data);
  }

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
}
