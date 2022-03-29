import 'package:flutter/material.dart';

import '../../../../utils/common_style.dart';

class SignInPageTextFormField extends StatelessWidget {
  const SignInPageTextFormField({
    this.controller,
    this.onChanged,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
  });

  static const _formFieldMargin = EdgeInsets.symmetric(vertical: 5);

  static const _formFieldContentPadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 5);

  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final void Function(String value)? onChanged;
  final bool obscureText;

  @override
  Widget build(BuildContext context) => Container(
        margin: _formFieldMargin,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: false,
            labelText: hintText,
            labelStyle: const TextStyle(
              fontSize: 12,
              color: CommonStyle.disabledColor,
              fontWeight: FontWeight.bold,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(color: CommonStyle.grey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(
                color: CommonStyle.enabledColor,
                width: 2,
              ),
            ),
            contentPadding: _formFieldContentPadding,
          ),
          keyboardType: keyboardType,
          onChanged: onChanged,
          obscureText: obscureText,
        ),
      );
}
