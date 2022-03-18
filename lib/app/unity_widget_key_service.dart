import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final unityWidgetKeyServiceProvider =
    Provider<UnityWidgetKeyService>((ref) => UnityWidgetKeyService());

class UnityWidgetKeyService {
  final key = GlobalKey(debugLabel: 'unitywidgetkey');
}
