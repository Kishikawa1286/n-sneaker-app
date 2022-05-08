import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/gallery_post/gallery_post_repository.dart';
import '../../repositories/package_info/package_info_repository.dart';
import '../../services/account/account_service.dart';

final accountPageViewModelProvider =
    AutoDisposeChangeNotifierProvider<AccountPageViewModel>(
  (ref) => AccountPageViewModel(
    ref.watch(accountServiceProvider),
    ref.read(packageInfoRepositoryProvider),
    ref.read(galleryPostRepositoryProvider),
  ),
);

class AccountPageViewModel extends ViewModelChangeNotifier {
  AccountPageViewModel(
    this._accountService,
    this._packageInfoRepository,
    this._galleryPostRepository,
  ) {
    _init();
  }

  final AccountService _accountService;
  final PackageInfoRepository _packageInfoRepository;
  final GalleryPostRepository _galleryPostRepository;

  String get accountId => _accountService.account?.id ?? '';
  int get point => _accountService.account?.point ?? 0;
  bool get isTrialActive => _accountService.isTrialActive();
  DateTime get trialExpiresAt =>
      _accountService.account?.createdAt
          .toDate()
          .add(const Duration(days: 7)) ??
      DateTime.now();

  String _version = '';
  String _buildNumber = '';
  bool _loading = false;

  String get version => _version;
  String get buildNumber => _buildNumber;
  bool get loading => _loading;

  /*
  SignInRewardModel? _signInReward;
  bool _alreadyHasSignInRewardCollectionProduct = false;
  bool _hasEnoughPoint = false;
  bool _loading = false;

  SignInRewardModel? get signInReward => _signInReward;
  bool get canGetSignInReward =>
      !_alreadyHasSignInRewardCollectionProduct && _hasEnoughPoint;
  bool get loading => _loading;
  */

  Future<void> _init() async {
    _version = await _packageInfoRepository.getVersion();
    _buildNumber = await _packageInfoRepository.getBuildNumber();
    /*
    final reward = await _signInRewardRepository.fetch();
    if (reward == null) {
      return;
    }
    _signInReward = reward;
    final account = _accountService.account;
    if (account == null) {
      return;
    }
    _hasEnoughPoint = account.point >= reward.consumedPoint;
    _alreadyHasSignInRewardCollectionProduct =
        await _collectionProductRepository.checkIfPurchased(
      accountId: account.id,
      productId: reward.productId,
    );
    */
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _accountService.signOut();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<String> clearBlockedAccountIds() async {
    if (_loading) {
      return '';
    }
    try {
      _loading = true;
      notifyListeners();

      await _galleryPostRepository.clearBlockedAccountIds();

      _loading = false;
      notifyListeners();
      return 'ブロックしたアカウントの一覧をクリアしました';
    } on Exception catch (e) {
      print(e);
      return 'ブロックしたアカウントの一覧のクリアに失敗しました';
    }
  }

  /*
  Future<String> getSignInReward() async {
    if (_alreadyHasSignInRewardCollectionProduct) {
      return '既に所持しています';
    }
    if (!_hasEnoughPoint) {
      return 'ポイントが不足しています';
    }
    try {
      _loading = true;
      notifyListeners();
      await _collectionProductRepository.addCollectionProductOnSignInReward();
      await _accountService.refetch();
      _alreadyHasSignInRewardCollectionProduct = true;
      _loading = false;
      notifyListeners();
      return '';
    } on Exception catch (e) {
      print(e);
      return 'ポイントとの交換に失敗しました';
    }
  }
  */
}
