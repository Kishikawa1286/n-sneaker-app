import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/common_style.dart';
import '../view_model.dart';

class SignInPageCarouselSelector extends StatelessWidget {
  const SignInPageCarouselSelector();

  static const _texts = ['ログイン', '新規登録', 'パスワード\nリセット'];

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: _texts
              .asMap()
              .map(
                (index, text) => MapEntry(
                  index,
                  _SignInPageCarouselSelectorItem(
                    index: index,
                    text: text,
                  ),
                ),
              )
              .values
              .toList(),
        ),
      );
}

class _SignInPageCarouselSelectorItem extends HookConsumerWidget {
  const _SignInPageCarouselSelectorItem({
    required this.text,
    required this.index,
  });

  final String text;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(signInPageViewModelProvider);
    final carouselItemShowed = index == viewModel.carouselIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          viewModel.carouselController.animateToPage(index);
        },
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: carouselItemShowed
                    ? CommonStyle.enabledColor
                    : CommonStyle.disabledColor,
                width: 2,
              ),
            ),
          ),
          alignment: Alignment.bottomLeft,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: carouselItemShowed
                    ? CommonStyle.enabledColor
                    : CommonStyle.disabledColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
