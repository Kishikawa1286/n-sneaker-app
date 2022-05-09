import 'package:flutter/material.dart';

import '../../../utils/common_style.dart';

void showSignUpRewardModal(BuildContext context) => showDialog<void>(
      context: context,
      builder: (context) => const SignUpRewardModal(),
    );

class SignUpRewardModal extends StatelessWidget {
  const SignUpRewardModal();

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(
              image:
                  AssetImage('assets/sign_up_reward/nevermind_app_present.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: Navigator.of(context).pop,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.7,
                    40,
                  ),
                  elevation: 5,
                  primary: CommonStyle.black,
                  onPrimary: CommonStyle.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'フィギュアを探す',
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: CommonStyle.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
