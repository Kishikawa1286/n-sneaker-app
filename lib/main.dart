import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'utils/on_generate_route.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        title: 'n-sneaker',
        onGenerateRoute: onGenerateRoute,
        initialRoute: '/',
      ),
    ),
  );
}
