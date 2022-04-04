import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/shared_preferences/shared_preferences_interface.dart';
import '../../interfaces/shared_preferences/shared_preferences_key.dart';

final collectionPageStateRepositoryProvider =
    Provider<CollectionPageStateRepository>(
  (ref) => CollectionPageStateRepository(
    ref.read(sharedPreferencesInterfaceProvider),
  ),
);

class CollectionPageStateRepository {
  const CollectionPageStateRepository(this._sharedPreferencesInterface);

  final SharedPreferencesInterface _sharedPreferencesInterface;

  Future<void> setLastSetCollectionPageBackgroundImageIndex(int index) =>
      _sharedPreferencesInterface.setInt(
        key: SharedPreferencesKey.lastSetCollectionPageBackgroundImageIndex,
        value: index,
      );

  Future<int> getLastSetCollectionPageBackgroundImageIndex() async =>
      (await _sharedPreferencesInterface.getInt(
        SharedPreferencesKey.lastSetCollectionPageBackgroundImageIndex,
      )) ??
      0;
}
