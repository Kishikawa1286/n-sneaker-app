import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/enum_to_string.dart';
import 'shared_preferences_key.dart';

final sharedPreferencesInterfaceProvider =
    Provider<SharedPreferencesInterface>((ref) => SharedPreferencesInterface());

class SharedPreferencesInterface {
  SharedPreferencesInterface();

  Future<void> setString({
    required SharedPreferencesKey key,
    required String value,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(enumToString(key), value);
  }

  Future<String?> getString(SharedPreferencesKey key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(enumToString(key));
  }

  Future<void> remove(SharedPreferencesKey key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(enumToString(key));
  }

  Future<void> setInt({
    required SharedPreferencesKey key,
    required int value,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(enumToString(key), value);
  }

  Future<int?> getInt(SharedPreferencesKey key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(enumToString(key));
  }
}
