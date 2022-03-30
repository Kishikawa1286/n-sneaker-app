import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../../../utils/common_style.dart';
import 'components/carousel_selector.dart';
import 'components/error_message.dart';
import 'components/heading.dart';
import 'components/main_heading.dart';
import 'components/policy.dart';
import 'components/text_form_field.dart';
import 'view_model.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(signInPageViewModelProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: FocusScope.of(context).unfocus,
          child: Center(
            child: Column(
              children: [
                const SignInPageMainHeading(),
                const SignInPageCarouselSelector(),
                CarouselSlider(
                  carouselController: viewModel.carouselController,
                  options: CarouselOptions(
                    height: 370,
                    onPageChanged: (index, reason) {
                      viewModel.setCarouselIndex(index);
                    },
                  ),
                  items: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Column(
                          children: [
                            const SignInPageHeading(text: 'ログイン'),
                            SignInPageTextFormField(
                              hintText: 'メールアドレス',
                              controller: viewModel.emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SignInPageTextFormField(
                              hintText: 'パスワード',
                              controller: viewModel.passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                            ),
                            SignInPageErrorMessage(
                              errorMessage: viewModel.signInErrorMessage,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30,
                              ),
                              child: SocialLoginButton(
                                height: 50,
                                text: 'ログイン',
                                borderRadius: 10,
                                backgroundColor: CommonStyle.black,
                                buttonType: SocialLoginButtonType.generalLogin,
                                onPressed: viewModel.signIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        child: Column(
                          children: [
                            const SignInPageHeading(text: '新規登録'),
                            SignInPageTextFormField(
                              hintText: 'メールアドレス',
                              controller: viewModel.emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SignInPageTextFormField(
                              hintText: 'パスワード',
                              controller: viewModel.passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                            ),
                            SignInPageErrorMessage(
                              errorMessage: viewModel.signUpErrorMessage,
                            ),
                            const SignInPagePolicy(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30,
                              ),
                              child: SocialLoginButton(
                                height: 50,
                                text: '新規登録',
                                borderRadius: 10,
                                backgroundColor: CommonStyle.black,
                                buttonType: SocialLoginButtonType.generalLogin,
                                onPressed: viewModel.signUp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        child: Column(
                          children: [
                            const SignInPageHeading(text: 'パスワードリセット'),
                            SignInPageTextFormField(
                              hintText: 'メールアドレス',
                              controller: viewModel.emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SignInPageErrorMessage(
                              errorMessage: viewModel.passwordResetErrorMessage,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30,
                              ),
                              child: SocialLoginButton(
                                height: 50,
                                text: '確認メール送信',
                                borderRadius: 10,
                                backgroundColor: CommonStyle.black,
                                buttonType: SocialLoginButtonType.generalLogin,
                                onPressed: () {
                                  viewModel.sendPasswordResetEmail();
                                  Flushbar<void>(
                                    message:
                                        '${viewModel.emailController.text}にメールを送信しました。',
                                    duration: const Duration(seconds: 1),
                                  ).show(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
