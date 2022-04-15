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

  PageViewModel _page({
    required String title,
    required String body,
    required String assetImagePath,
    required PageDecoration pageDecoration,
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
        titleWidget: Builder(
          builder: (context) => Container(
            width: MediaQuery.of(context).size.width * 0.95,
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: CommonStyle.white,
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
        ),
        bodyWidget: Builder(
          builder: (context) => Container(
            width: MediaQuery.of(context).size.width * 0.95,
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: CommonStyle.white,
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
        ),
        decoration: pageDecoration,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(onboardingPageViewModelProvider);
    final pageDecoration = PageDecoration(
      boxDecoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/wave_background/Wave.png'),
          fit: BoxFit.cover,
        ),
      ),
      titleTextStyle: Theme.of(context).textTheme.titleMedium ??
          const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      bodyTextStyle: Theme.of(context).textTheme.bodyMedium ??
          const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      globalBackgroundColor: CommonStyle.white,
      pages: [
        _page(
          title: 'N-Sneaker',
          body: 'N-Sneakerはデジタルスニーカーを\n「買って、集めて、遊べる」\n総合プラットフォームです',
          assetImagePath: 'assets/onboarding_images/onboarding1.jpg',
          pageDecoration: pageDecoration,
        ),
        _page(
          title: 'マーケット',
          body: '気にいったスニーカーを選んで購入',
          assetImagePath: 'assets/onboarding_images/onboarding2.jpg',
          pageDecoration: pageDecoration,
        ),
        _page(
          title: 'コレクション',
          body: '買ったスニーカーはコレクションして\n手のひらの中で好きなだけ\n転がすことができます',
          assetImagePath: 'assets/onboarding_images/onboarding3.jpg',
          pageDecoration: pageDecoration,
        ),
        _page(
          title: 'AR',
          body: 'お気に入りのスニーカーを\nARで私たちの日常に持ってこよう',
          assetImagePath: 'assets/onboarding_images/onboarding4.jpg',
          pageDecoration: pageDecoration,
        ),
        _page(
          title: '',
          body: 'さあ、新しいファッションライフを\n始めましょう！',
          assetImagePath: 'assets/onboarding_images/onboarding5.jpg',
          pageDecoration: pageDecoration,
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
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      dotsDecorator: const DotsDecorator(
        size: Size(10, 10),
        color: CommonStyle.grey,
        activeSize: Size(22, 10),
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
    );
  }
}
