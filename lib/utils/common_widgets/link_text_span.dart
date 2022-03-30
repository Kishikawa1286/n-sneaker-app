import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common_style.dart';

TextSpan linkTextSpan(
  BuildContext context, {
  required String url,
  required String text,
}) =>
    TextSpan(
      text: text,
      style: const TextStyle(
        color: CommonStyle.linkColor,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          if (await canLaunch(url)) {
            await launch(url);
          }
        },
    );
