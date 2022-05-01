import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../../../utils/common_style.dart';
import '../../../utils/common_widgets/common_text_form_field.dart';
import '../../../utils/common_widgets/floating_back_button.dart';
import '../../../utils/common_widgets/link_text_span.dart';
import '../../../utils/common_widgets/overlay_loading.dart';
import '../../../utils/show_flushbar.dart';
import '../password_reset_page/password_reset_page.dart';
import 'view_model.dart';

void pushSignInPage(BuildContext context) =>
    Navigator.of(context).pushNamed('sign_in');

class SignInPage extends HookConsumerWidget {
  const SignInPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(signInPageViewModelProvider);
    return Scaffold(
      backgroundColor: CommonStyle.scaffoldBackgroundColor,
      body: OverlayLoading(
        visible: viewModel.processing,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: FocusScope.of(context).unfocus,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: const Image(
                                  image: AssetImage(
                                    'assets/launcher_icon/icon.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Nevermind',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Stack(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                            Align(
                              child: Container(
                                color: CommonStyle.scaffoldBackgroundColor,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'ログイン',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Material(
                          elevation: 5,
                          child: SocialLoginButton(
                            buttonType: SocialLoginButtonType.google,
                            onPressed: () async {
                              final message =
                                  await viewModel.signInWithGoogle();
                              if (message.isNotEmpty) {
                                await showFlushbar(
                                  context,
                                  message: message,
                                );
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            text: 'Googleでサインイン',
                          ),
                        ),
                      ),
                      viewModel.showSignInWithAppleButton
                          ? Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Material(
                                elevation: 5,
                                child: SocialLoginButton(
                                  buttonType: SocialLoginButtonType.apple,
                                  onPressed: () async {
                                    final message =
                                        await viewModel.signInWithApple();
                                    if (message.isNotEmpty) {
                                      await showFlushbar(
                                        context,
                                        message: message,
                                      );
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  text: 'Appleでサインイン',
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          'Eメールで登録',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.only(top: 10),
                        child: CommonTextFormField(
                          controller: viewModel.emailController,
                          hintText: 'メールアドレス',
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.only(top: 5),
                        child: CommonTextFormField(
                          controller: viewModel.passwordController,
                          hintText: 'パスワード',
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                        ),
                      ),
                      Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.only(top: 15),
                        child: Material(
                          elevation: 5,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              SocialLoginButton(
                                buttonType: SocialLoginButtonType.generalLogin,
                                backgroundColor: CommonStyle.white,
                                textColor: CommonStyle.black,
                                onPressed: () async {
                                  final message = await viewModel
                                      .signInWithEmailAndPassword();
                                  if (message.isNotEmpty) {
                                    await showFlushbar(
                                      context,
                                      message: message,
                                    );
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                                text: 'Eメールでサインイン',
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 23),
                                  child: Icon(
                                    Icons.mail_outline,
                                    color: CommonStyle.black,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: CommonStyle.black),
                            children: [
                              const TextSpan(text: 'パスワードをお忘れの場合は '),
                              linkTextSpan(
                                text: 'パスワードの再設定',
                                onTap: () => pushPasswordResetPage(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 40,
              left: 5,
              child: FloatingBackButton(
                buttonColor: CommonStyle.transparent,
                iconColor: CommonStyle.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
