import 'package:flutter/material.dart';

import '../app/views/account_gallery_posts_page/account_gallery_posts_page.dart';
import '../app/views/glb_file_viewer_page/glb_file_viewer_page.dart';
import '../app/views/market_detail_page/market_detail_page.dart';
import '../app/views/onboarding_page/onboarding_page.dart';
import '../app/views/password_reset_page/password_reset_page.dart';
import '../app/views/root/root.dart';
import '../app/views/sign_in_page/sign_in_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) =>
    PageRouteBuilder<Widget>(
      settings: settings,
      pageBuilder: (_, __, ___) {
        final name = settings.name;
        if (name == null || name == 'root') {
          return const Root();
        }

        if (name == 'onboarding') {
          return const OnboardingPage();
        }

        if (name == 'sign_in') {
          return const SignInPage();
        }

        if (name == 'password_reset') {
          return const PasswordResetPage();
        }

        if (name == 'account_gallery_posts') {
          return const AccountGalleryPostsPage();
        }

        if (name.startsWith('product_detail')) {
          final productId =
              RegExp('(?<=product_detail/)(.*)').firstMatch(name)?.group(0);
          if (productId == null) {
            return const Root();
          }
          return MarketDetailPage(productId: productId);
        }

        if (name.startsWith('glb_file_viewer')) {
          final productId = RegExp('(?<=glb_file_viewer/)(.*)(?=/)')
              .firstMatch(name)
              ?.group(0);
          if (productId == null) {
            return const Root();
          }
          final productGlbFileId =
              RegExp('(?<=glb_file_viewer/$productId/)(.*)')
                  .firstMatch(name)
                  ?.group(0);
          if (productGlbFileId == null) {
            return const Root();
          }
          return GlbFileViewerPage(
            productId: productId,
            productGlbFileId: productGlbFileId,
          );
        }

        return const Root();
      },
    );
