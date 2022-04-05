import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/shared_preferences/shared_preferences_interface.dart';
import '../../interfaces/shared_preferences/shared_preferences_key.dart';

final onboardingStateRepositoryProvider = Provider<OnboardingStateRepository>(
  (ref) =>
      OnboardingStateRepository(ref.read(sharedPreferencesInterfaceProvider)),
);

class OnboardingStateRepository {
  const OnboardingStateRepository(this._sharedPreferencesInterface);

  final SharedPreferencesInterface _sharedPreferencesInterface;

  Future<void> setOnboardingDone() => _sharedPreferencesInterface.setBool(
        key: SharedPreferencesKey.onboardingDone,
        value: true,
      );

  Future<bool> getWhetherOnboardingDone() async =>
      (await _sharedPreferencesInterface
          .getBool(SharedPreferencesKey.onboardingDone)) ??
      false;
}
