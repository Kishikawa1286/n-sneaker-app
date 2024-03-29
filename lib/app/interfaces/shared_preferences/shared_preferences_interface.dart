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

  Future<void> setStringList({
    required SharedPreferencesKey key,
    required List<String> value,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList(enumToString(key), value);
  }

  Future<List<String>?> getStringList(SharedPreferencesKey key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(enumToString(key));
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

  Future<void> setBool({
    required SharedPreferencesKey key,
    required bool value,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(enumToString(key), value);
  }

  Future<bool?> getBool(SharedPreferencesKey key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(enumToString(key));
  }
}
