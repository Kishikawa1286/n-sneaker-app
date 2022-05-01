import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../../../utils/common_style.dart';
import '../../../utils/common_widgets/common_text_form_field.dart';
import '../../../utils/common_widgets/floating_back_button.dart';
import '../../../utils/common_widgets/overlay_loading.dart';
import '../../../utils/show_flushbar.dart';
import 'view_model.dart';

void pushPasswordResetPage(BuildContext context) =>
    Navigator.of(context).pushNamed('password_reset');

class PasswordResetPage extends HookConsumerWidget {
  const PasswordResetPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(signInPageViewModelProvider);
    return Scaffold(
      backgroundColor: CommonStyle.scaffoldBackgroundColor,
      body: OverlayLoading(
        visible: viewModel.processing,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              GestureDetector(
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
                                  'パスワードリセット',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.only(top: 50),
                        child: CommonTextFormField(
                          controller: viewModel.emailController,
                          hintText: 'メールアドレス',
                          keyboardType: TextInputType.text,
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
                                  final message =
                                      await viewModel.sendPasswordResetEmail();
                                  if (message.isNotEmpty) {
                                    await showFlushbar(
                                      context,
                                      message: message,
                                    );
                                  }
                                },
                                text: 'パスワードリセットのメールを送信',
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
                    ],
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
      ),
    );
  }
}
