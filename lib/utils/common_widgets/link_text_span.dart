import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../common_style.dart';

TextSpan linkTextSpan({
  required void Function() onTap,
  required String text,
}) =>
    TextSpan(
      text: text,
      style: const TextStyle(
        color: CommonStyle.linkColor,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          onTap();
        },
    );
