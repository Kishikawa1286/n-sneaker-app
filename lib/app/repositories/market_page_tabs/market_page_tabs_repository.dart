import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';

final marketPageTabsRepositoryProvider = Provider<MarketPageTabsRepository>(
  (ref) => MarketPageTabsRepository(ref.read(cloudFirestoreInterfaceProvider)),
);

class MarketPageTabsRepository {
  MarketPageTabsRepository(this._cloudFirestoreInterface);

  final CloudFirestoreInterface _cloudFirestoreInterface;

  Future<List<String>> fetchMarketPageTabs() async {
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: marketPageTabsCollectionPath,
      queryBuilder: (query) => query.limit(16),
    );
    final docs = snapshot.docs;
    if (docs.isEmpty) {
      return [];
    }
    final data = docs.first.data();
    return List<String>.from(data['tab_titles'] as List<dynamic>);
  }
}
