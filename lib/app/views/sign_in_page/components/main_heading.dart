import 'package:flutter/material.dart';

class SignInPageMainHeading extends StatelessWidget {
  const SignInPageMainHeading();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Text(
          'N-Sneaker',
          textScaleFactor: 1,
          style: Theme.of(context).textTheme.headline2,
        ),
      );
}
