import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../../../utils/common_style.dart';
import '../../../utils/common_widgets/loading_page.dart';
import 'components/carousel_selector.dart';
import 'components/error_message.dart';
import 'components/heading.dart';
import 'components/policy.dart';
import 'components/text_form_field.dart';
import 'view_model.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(signInPageViewModelProvider);

    if (viewModel.waiting) {
      return const LoadingPage();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: FocusScope.of(context).unfocus,
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 80, bottom: 10),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'N-Sneaker',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
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
