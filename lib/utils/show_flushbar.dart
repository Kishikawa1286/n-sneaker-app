import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<void> showFlushbar(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(milliseconds: 3000),
}) =>
    Flushbar<void>(
      message: message,
      duration: duration,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      margin: const EdgeInsets.symmetric(horizontal: 25),
    ).show(context);
