import 'package:flutter/material.dart';

import '../../../../utils/common_style.dart';

class SignInPageErrorMessage extends StatelessWidget {
  const SignInPageErrorMessage({required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    if (errorMessage.isEmpty) {
      return const SizedBox();
    }
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: const TextStyle(
          color: CommonStyle.errorColor,
          fontSize: 12,
        ),
        text: errorMessage,
      ),
    );
  }
}
