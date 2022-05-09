import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../utils/common_style.dart';
import 'view_model.dart';

void pushOnboardingPage(BuildContext context) {
  Navigator.of(context).pushNamed('onboarding');
}

class OnboardingPage extends HookConsumerWidget {
  const OnboardingPage();

  PageViewModel _page(
    BuildContext context, {
    required String title,
    required String body,
    required String assetImagePath,
    required String backgroundImagePath,
  }) =>
      PageViewModel(
        image: Container(
          height: 500,
          margin: const EdgeInsets.only(top: 45),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: AssetImage(assetImagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        titleWidget: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          margin: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            color: CommonStyle.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        bodyWidget: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          margin: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            color: CommonStyle.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              body,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        decoration: PageDecoration(
          boxDecoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImagePath),
              fit: BoxFit.contain,
            ),
          ),
          titleTextStyle: Theme.of(context).textTheme.titleMedium ??
              const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          bodyTextStyle: Theme.of(context).textTheme.bodyMedium ??
              const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
          imagePadding: EdgeInsets.zero,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(onboardingPageViewModelProvider);
    return IntroductionScreen(
      globalBackgroundColor: CommonStyle.white,
      pages: [
        _page(
          context,
          title: 'Nevermind',
          body: 'Nevermindは\n「毎日に小さなオシャレをプラスする」\nファッションフィギュアのアプリです',
          assetImagePath: 'assets/onboarding_images/onboarding1.jpg',
          backgroundImagePath: 'assets/onboarding_images/Blob1.png',
        ),
        _page(
          context,
          title: 'マーケット',
          body: '気にいったフィギュアを選んで購入',
          assetImagePath: 'assets/onboarding_images/onboarding2.jpg',
          backgroundImagePath: 'assets/onboarding_images/Blob2.png',
        ),
        _page(
          context,
          title: 'AR',
          body: 'お気に入りのフィギュアを\nARで私たちの日常に持ってこよう',
          assetImagePath: 'assets/onboarding_images/onboarding3.jpg',
          backgroundImagePath: 'assets/onboarding_images/Blob3.png',
        ),
        _page(
          context,
          title: 'ギャラリー',
          body: '上手く撮れたフィギュアの写真は\nギャラリーでみんなとシェアしよう',
          assetImagePath: 'assets/onboarding_images/onboarding4.jpg',
          backgroundImagePath: 'assets/onboarding_images/Blob4.png',
        ),
        _page(
          context,
          title: 'コレクション',
          body: '買ったフィギュアはコレクションして\n手のひらの中で好きなだけ\n転がすことができます',
          assetImagePath: 'assets/onboarding_images/onboarding5.jpg',
          backgroundImagePath: 'assets/onboarding_images/Blob5.png',
        ),
        _page(
          context,
          title: '',
          body: 'さあ、Nevermindと一緒に\n新しい日常を始めましょう！',
          assetImagePath: 'assets/onboarding_images/onboarding6.jpg',
          backgroundImagePath: 'assets/onboarding_images/Blob1.png',
        ),
      ],
      next: const Icon(Icons.arrow_forward_ios, color: CommonStyle.black),
      nextStyle: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(CommonStyle.transparent),
        foregroundColor:
            MaterialStateProperty.all<Color>(CommonStyle.transparent),
      ),
      done: Text(
        '始める',
        style: Theme.of(context).textTheme.button,
      ),
      onDone: () {
        viewModel.onDone();
        Navigator.of(context).pop();
      },
      showSkipButton: true,
      skip: Text(
        'スキップ',
        style: Theme.of(context).textTheme.button,
      ),
      onSkip: () {
        viewModel.onDone();
        Navigator.of(context).pop();
      },
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(4),
      controlsPadding: const EdgeInsets.fromLTRB(2, 4, 2, 4),
      dotsDecorator: const DotsDecorator(
        size: Size(10, 10),
        color: CommonStyle.grey,
        activeSize: Size(16, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: CommonStyle.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      dotsFlex: 0,
    );
  }
}
