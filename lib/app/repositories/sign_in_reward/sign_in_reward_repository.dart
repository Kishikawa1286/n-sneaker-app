import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import '../product/product_model.dart';
import 'sign_in_reward_model.dart';

final signInRewardRepositoryProvider = Provider<SignInRewardRepository>(
  (ref) => SignInRewardRepository(ref.read(cloudFirestoreInterfaceProvider)),
);

class SignInRewardRepository {
  const SignInRewardRepository(this._cloudFirestoreInterface);

  final CloudFirestoreInterface _cloudFirestoreInterface;

  Future<SignInRewardModel?> fetch() async {
    try {
      final signInRewardsSnapshot =
          await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
        collectionPath: signInRewardsCollectionPath,
      );
      final signInRewardDocuments = signInRewardsSnapshot.docs;
      if (signInRewardDocuments.isEmpty) {
        throw Exception('signInRewardsSnapshot.docs is empty.');
      }
      final signInRewardDocument = signInRewardDocuments.first;
      final signInRewardData = signInRewardDocument.data();
      final productId = signInRewardData['product_id'] as String?;
      if (productId == null) {
        throw Exception('signInRewardData["product_id"] is null');
      }
      final productSnapshot =
          await _cloudFirestoreInterface.fetchDocumentSnapshot(
        documentPath: productDocumentPath(productId),
      );
      return SignInRewardModel.fromDocumentSnapshot(
        snapshot: signInRewardDocument,
        product: ProductModel.fromDocumentSnapshot(productSnapshot),
      );
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
}
