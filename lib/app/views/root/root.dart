import 'dart:async';

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
import '../gallery_page/gallery_page.dart';
import '../market_page/market_page.dart';
import '../onboarding_page/onboarding_page.dart';
import '../sign_up_page/sign_up_page.dart';
import 'invalid_build_number_page.dart';
import 'maintainance_page.dart';
import 'sign_up_reward_modal.dart';
import 'view_model.dart';

class Root extends HookConsumerWidget {
  const Root();

  static const _labelTextStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(rootViewModelProvider);
    final onboardingDone = viewModel.onboardingDone;
    if (onboardingDone == null) {
      return const LoadingPage();
    }

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
          final onboardingDone = viewModel.onboardingDone;
          if (authState == null ||
              authState == AuthState.notChecked ||
              onboardingDone == null) {
            return const LoadingPage();
          }
          if (authState == AuthState.signOut) {
            return const SignUpPage();
          }
          return Scaffold(
            backgroundColor: CommonStyle.scaffoldBackgroundColor,
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: CommonStyle.disabledColor,
              selectedItemColor: CommonStyle.enabledColor,
              currentIndex: viewModel.currentIndex,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              selectedLabelStyle: _labelTextStyle,
              unselectedLabelStyle: _labelTextStyle,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag),
                  label: 'マーケット',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.center_focus_strong),
                  label: 'AR',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.photo),
                  label: 'ギャラリー',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_rounded),
                  label: 'コレクション',
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
                    // login modal related
                    /*
                    if (authState == AuthState.signInAndGetPoint) {
                      // wait MarketPage built
                      Timer(const Duration(milliseconds: 500), () {
                        if (!viewModel.pointModalPushed) {
                          showPointModal(
                            context,
                            onPressed: () {
                              Navigator.of(context).pop();
                              viewModel.setIndex(3);
                            },
                          );
                          viewModel.onPointModalPushed();
                        }
                      });
                    }
                    */
                    if (authState == AuthState.signInWithNewAccount) {
                      // ページのビルドを待つ
                      // 特典→オンボーディングの順にpush
                      Timer(const Duration(milliseconds: 480), () {
                        if (!viewModel.signUpRewardModalPushed) {
                          showSignUpRewardModal(context);
                          viewModel.onSignUpRewardModalPushed();
                        }
                      });
                      Timer(const Duration(milliseconds: 500), () {
                        if (!onboardingDone && !viewModel.onboardingPushed) {
                          pushOnboardingPage(context);
                          viewModel.onOnboardingPushed();
                        }
                      });
                    }
                    return const MarketPage();

                  case 1:
                    return const ArPage();

                  case 2:
                    return const GalleryPage();

                  case 3:
                    return const CollectionPage();

                  case 4:
                    return AccountPage(goToArPage: () => viewModel.setIndex(1));

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
