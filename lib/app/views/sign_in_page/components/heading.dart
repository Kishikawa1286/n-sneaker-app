import 'package:flutter/material.dart';

class SignInPageHeading extends StatelessWidget {
  const SignInPageHeading({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
            ),
          ),
        ),
        alignment: Alignment.bottomLeft,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      );
}
