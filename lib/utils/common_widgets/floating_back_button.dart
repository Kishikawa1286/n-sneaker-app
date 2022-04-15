import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common_style.dart';

class FloatingBackButton extends StatelessWidget {
  const FloatingBackButton({
    this.buttonColor = CommonStyle.transparentBlack,
    this.iconColor = CommonStyle.white,
  });

  final Color buttonColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: Navigator.of(context).pop,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shadowColor: CommonStyle.transparent,
          primary: buttonColor,
          onPrimary: buttonColor,
          onSurface: CommonStyle.transparent,
          shape: const CircleBorder(
            side: BorderSide(
              width: 0,
              color: CommonStyle.transparent,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 9),
          child: Icon(
            Icons.arrow_back_ios,
            size: 26,
            color: iconColor,
          ),
        ),
      );
}
