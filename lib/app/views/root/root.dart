import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/common_style.dart';
import '../../../utils/common_widgets/loading_page.dart';
import '../../../utils/common_widgets/unity_widget_initializer/unity_widget_initializer.dart';
import '../../services/account/account_service.dart';
import '../account_page/account_page.dart';
import '../ar_page/ar_page.dart';
import '../collection_page/collection_page.dart';
import '../market_page/market_page.dart';
import '../sign_in_page/sign_in_page.dart';
import 'invalid_build_number_page.dart';
import 'maintainance_page.dart';
import 'view_model.dart';

class Root extends HookConsumerWidget {
  const Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(rootViewModelProvider);

    if (viewModel.underMaintainance) {
      return MaintainancePage(message: viewModel.maintainanceMessage);
    }

    if (!viewModel.isLaunchableBuildNumber) {
      return InvalidBuildNumberPage(url: viewModel.storeUrl);
    }

    return UnityWidgetInitializer(
      afterInitialized: (context) => StreamBuilder<AuthState?>(
        stream: viewModel.authStateStream,
        builder: (context, snapshot) {
          final authState = snapshot.data;
          if (authState == null || authState == AuthState.notChecked) {
            return const LoadingPage();
          }
          if (authState == AuthState.signOut) {
            return const SignInPage();
          }
          return Scaffold(
            backgroundColor: CommonStyle.scaffoldBackgroundColor,
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: CommonStyle.disabledColor,
              selectedItemColor: CommonStyle.enabledColor,
              currentIndex: viewModel.currentIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag),
                  label: 'マーケット',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_rounded),
                  label: 'コレクション',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.center_focus_strong),
                  label: 'AR',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: '設定',
                ),
              ],
              onTap: viewModel.setIndex,
            ),
            body: Builder(
              builder: (context) {
                switch (viewModel.currentIndex) {
                  case 0:
                    return const MarketPage();
                  case 1:
                    return const CollectionPage();
                  case 2:
                    return const ArPage();
                  case 3:
                    return const AccountPage();
                  default:
                    return const LoadingPage();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
