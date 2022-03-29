import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common_style.dart';

class FloatingBackButton extends StatelessWidget {
  const FloatingBackButton();

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: Navigator.of(context).pop,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shadowColor: CommonStyle.transparent,
          primary: CommonStyle.transparentBlack,
          onPrimary: CommonStyle.transparentBlack,
          shape: const CircleBorder(
            side: BorderSide(
              width: 0,
              color: CommonStyle.transparent,
            ),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.only(left: 9),
          child: Icon(
            Icons.arrow_back_ios,
            size: 26,
            color: CommonStyle.white,
          ),
        ),
      );
}
