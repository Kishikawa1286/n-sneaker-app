import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';

final marketPageViewModelProvider =
    AutoDisposeChangeNotifierProvider<MarketPageViewModel>(
  (ref) => MarketPageViewModel(),
);

class MarketPageViewModel extends ViewModelChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (_currentIndex == index) {
      return;
    }
    _currentIndex = index;
    notifyListeners();
    print(index);
  }
}
