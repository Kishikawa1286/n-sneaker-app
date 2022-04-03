import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import 'launch_configs.dart';

final launchConfigsRepositoryProvider = Provider<LaunchConfigsRepository>(
  (ref) => LaunchConfigsRepository(ref.read(cloudFirestoreInterfaceProvider)),
);

class LaunchConfigsRepository {
  LaunchConfigsRepository(this._cloudFirestoreInterface);

  final CloudFirestoreInterface _cloudFirestoreInterface;

  Future<LaunchConfigsModel> fetch() async {
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: launchConfigsCollection,
      queryBuilder: (query) => query.limit(16),
    );
    final docs = snapshot.docs;
    if (docs.isEmpty) {
      throw Exception('To fetch configs failed.');
    }
    return LaunchConfigsModel.fromDocumentSnapshot(docs.first);
  }
}
