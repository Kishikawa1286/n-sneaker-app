import 'package:flutter/material.dart';

import '../../../../utils/common_style.dart';
import '../../../../utils/common_widgets/link_text_span.dart';
import '../../../../utils/environment_variables.dart';

class SignInPagePolicy extends StatelessWidget {
  const SignInPagePolicy();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            style: const TextStyle(
              color: CommonStyle.grey,
              fontSize: 12,
            ),
            children: <TextSpan>[
              const TextSpan(text: '新規登録することで'),
              linkTextSpan(context, url: termsOfServiceUrl, text: '利用規約'),
              const TextSpan(text: '・'),
              linkTextSpan(context, url: privacyPolicyUrl, text: 'プライバシーポリシー'),
              const TextSpan(text: 'に同意したことになります。'),
            ],
          ),
        ),
      );
}
