import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/onboarding_state/onboarding_state_repository.dart';

final onboardingPageViewModelProvider =
    AutoDisposeChangeNotifierProvider<OnboardingPageViewModel>(
  (ref) => OnboardingPageViewModel(ref.read(onboardingStateRepositoryProvider)),
);

class OnboardingPageViewModel extends ViewModelChangeNotifier {
  OnboardingPageViewModel(this._onboardingStateRepository);

  final OnboardingStateRepository _onboardingStateRepository;

  void onDone() {
    _onboardingStateRepository.setOnboardingDone();
  }
}
