import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/view_model_change_notifier.dart';
import '../../../services/account/account_service.dart';

final pointModalViewModelProvider = AutoDisposeChangeNotifierProvider(
  (ref) => PointModalViewModel(ref.watch(accountServiceProvider)),
);

class PointModalViewModel extends ViewModelChangeNotifier {
  PointModalViewModel(this._accountService);

  final AccountService _accountService;

  int get point => _accountService.account?.point ?? 0;
}
