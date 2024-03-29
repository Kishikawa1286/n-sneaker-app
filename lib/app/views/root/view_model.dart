import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/environment_variables.dart';
import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/launch_configs/launch_configs.dart';
import '../../repositories/launch_configs/launch_configs_repository.dart';
import '../../repositories/onboarding_state/onboarding_state_repository.dart';
import '../../repositories/package_info/package_info_repository.dart';
import '../../services/account/account_service.dart';

final rootViewModelProvider = ChangeNotifierProvider(
  (ref) => RootViewModel(
    ref.read(launchConfigsRepositoryProvider),
    ref.read(packageInfoRepositoryProvider),
    ref.read(onboardingStateRepositoryProvider),
    ref.watch(accountServiceProvider),
  ),
);

class RootViewModel extends ViewModelChangeNotifier {
  RootViewModel(
    this._launchConfigsRepository,
    this._packageInfoRepository,
    this._onboardingStateRepository,
    this._accountService,
  ) {
    _init();
  }

  final LaunchConfigsRepository _launchConfigsRepository;
  final PackageInfoRepository _packageInfoRepository;
  final OnboardingStateRepository _onboardingStateRepository;
  final AccountService _accountService;

  Stream<AuthState?> get authStateStream => _accountService.authStateStream;

  LaunchConfigsModel? _configs;
  int _localBuildNumber = 0;
  int _currentIndex = 0;
  bool? _onboardingDone;
  bool _onboardingPushed = false;
  bool _signUpRewardModalPushed = false;

  bool get isLaunchableBuildNumber =>
      _localBuildNumber >= (_configs?.launchableBuildNumber ?? 1000);
  bool get underMaintainance => _configs?.underMaintenance ?? true;
  String get maintainanceMessage => _configs?.maintainanceMessage ?? '';
  bool? get onboardingDone => _onboardingDone;
  bool get onboardingPushed => _onboardingPushed;
  bool get signUpRewardModalPushed => _signUpRewardModalPushed;

  String get storeUrl {
    if (Platform.isIOS) {
      return appStoreUrl;
    }
    if (Platform.isAndroid) {
      return playStoreUrl;
    }
    return '';
  }

  int get currentIndex => _currentIndex;

  Future<void> _init() async {
    try {
      _onboardingDone =
          await _onboardingStateRepository.getWhetherOnboardingDone();
      _configs = await _launchConfigsRepository.fetch();
      _localBuildNumber =
          int.tryParse(await _packageInfoRepository.getBuildNumber()) ?? 0;
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void onOnboardingPushed() {
    _onboardingPushed = true;
  }

  void onSignUpRewardModalPushed() {
    _signUpRewardModalPushed = true;
  }
}
