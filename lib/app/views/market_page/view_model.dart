import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/market_page_tabs/market_page_tabs_repository.dart';

final marketPageViewModelProvider =
    AutoDisposeChangeNotifierProvider<MarketPageViewModel>(
  (ref) => MarketPageViewModel(ref.read(marketPageTabsRepositoryProvider)),
);

class MarketPageViewModel extends ViewModelChangeNotifier {
  MarketPageViewModel(this._marketPageTabsRepository) {
    _fetchTabs();
  }

  final MarketPageTabsRepository _marketPageTabsRepository;

  List<String> _tabTitles = [];
  int _currentIndex = 0;

  List<String> get tabTitles => _tabTitles;
  int get currentIndex => _currentIndex;

  Future<void> _fetchTabs() async {
    _tabTitles = await _marketPageTabsRepository.fetchMarketPageTabs();
    notifyListeners();
  }

  void setIndex(int index) {
    if (_currentIndex == index) {
      return;
    }
    _currentIndex = index;
    notifyListeners();
  }
}
