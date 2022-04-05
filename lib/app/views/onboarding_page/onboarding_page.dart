import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../utils/common_style.dart';
import 'view_model.dart';

void pushOnboardingPage(BuildContext context) {
  Navigator.of(context).pushNamed('onboarding');
}

class OnboardingPage extends HookConsumerWidget {
  const OnboardingPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(onboardingPageViewModelProvider);
    final pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.titleMedium ??
          const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      bodyTextStyle: Theme.of(context).textTheme.bodyMedium ??
          const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
      bodyPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      pageColor: CommonStyle.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      globalBackgroundColor: CommonStyle.white,
      pages: [
        PageViewModel(
          title: 'スニーカーを集める',
          body: 'デジタルスニーカーを集めよう👟',
          image: Container(
            margin: const EdgeInsets.only(top: 100, left: 30, right: 30),
            height: 700,
            child: Card(
              elevation: 7,
              child: ModelViewer(
                src: 'assets/onboarding_glb_file/white_mark_both.glb',
                alt: 'Model Viewer',
                ar: false,
                cameraControls: true,
                autoRotate: true,
                autoRotateDelay: 20000,
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'スニーカーを集める',
          body: 'デジタルスニーカーを集めよう👟',
          image: SizedBox(
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const Image(
                image: AssetImage('assets/launcher_icon/icon.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'スニーカーを集める',
          body: 'デジタルスニーカーを集めよう👟',
          image: SizedBox(
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const Image(
                image: AssetImage('assets/launcher_icon/icon.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
      ],
      skipOrBackFlex: 0,
      nextFlex: 0,
      onDone: () {
        viewModel.onDone();
        Navigator.of(context).pop();
      },
      next: const Icon(Icons.arrow_forward, color: CommonStyle.black),
      nextStyle: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(CommonStyle.transparent),
        foregroundColor:
            MaterialStateProperty.all<Color>(CommonStyle.transparent),
      ),
      done: Text('進む', style: Theme.of(context).textTheme.button),
      doneStyle: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(CommonStyle.transparent),
        foregroundColor:
            MaterialStateProperty.all<Color>(CommonStyle.transparent),
      ),
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
