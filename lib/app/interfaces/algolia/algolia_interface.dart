import 'package:algolia/algolia.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/environment_variables.dart';

final Provider<AlgoliaInterface> algoliaInterfaceProvider =
    Provider<AlgoliaInterface>((ref) => const AlgoliaInterface());

class AlgoliaInterface {
  const AlgoliaInterface();
  static const Algolia algolia = Algolia.init(
    applicationId: algoliaApplicationId,
    apiKey: algoliaApikey,
  );

  Future<AlgoliaQuerySnapshot> query({
    required String algoliaIndex,
    required AlgoliaQuery Function(AlgoliaQuery query) queryBuilder,
  }) {
    AlgoliaQuery query = algolia.instance.index(algoliaIndex);
    query = queryBuilder(query);
    return query.getObjects();
  }
}
