import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/package_info/package_info_repository.dart';
import '../../services/account/account_service.dart';

final accountPageViewModelProvider =
    AutoDisposeChangeNotifierProvider<AccountPageViewModel>(
  (ref) => AccountPageViewModel(
    ref.watch(accountServiceProvider),
    ref.read(packageInfoRepositoryProvider),
  ),
);

class AccountPageViewModel extends ViewModelChangeNotifier {
  AccountPageViewModel(
    this._accountService,
    this._packageInfoRepository,
  ) {
    _init();
  }

  final AccountService _accountService;
  final PackageInfoRepository _packageInfoRepository;

  String get accountId => _accountService.account?.id ?? '';
  String get accountEmail => _accountService.account?.email ?? '';

  String _version = '';
  String _buildNumber = '';

  String get version => _version;
  String get buildNumber => _buildNumber;

  Future<void> _init() async {
    _version = await _packageInfoRepository.getVersion();
    _buildNumber = await _packageInfoRepository.getBuildNumber();
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _accountService.signOut();
    } on Exception catch (e) {
      print(e);
    }
  }
}
