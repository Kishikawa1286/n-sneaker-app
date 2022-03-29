// ignore_for_file: constant_identifier_names

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/enum_to_string.dart';
import '../../../../utils/environment_variables.dart';
import 'analytics_content_type.dart';
import 'analytics_login_method.dart';
import 'analytics_sign_up_method.dart';

final firebaseAnalyticsInterfaceProvider =
    Provider((ref) => const FirebaseAnalyticsInterface());

class FirebaseAnalyticsInterface {
  const FirebaseAnalyticsInterface();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  void setUserProperties({required String id}) {
    _analytics
      ..setUserId(id: id)
      ..setUserProperty(name: 'user_id', value: id);
  }

  void _runIfAnalyticsEnabled(void Function() body) {
    if (isEnabledAnalytics) {
      body();
    }
  }

  void logLogin({required AnalyticsLoginMethod loginMethod}) =>
      _runIfAnalyticsEnabled(
        () => _analytics.logLogin(loginMethod: enumToString(loginMethod)),
      );

  void logSignUp({required AnalyticsSignUpMethod signUpMethod}) =>
      _runIfAnalyticsEnabled(
        () => _analytics.logSignUp(signUpMethod: enumToString(signUpMethod)),
      );

  void logSearch({required String searchTerm}) => _runIfAnalyticsEnabled(
        () => _analytics.logSearch(searchTerm: searchTerm),
      );

  void logShare({
    required String itemId,
    required AnalyticsContentType contentType,
    String method = 'unknown',
  }) =>
      _runIfAnalyticsEnabled(
        () => _analytics.logShare(
          contentType: enumToString(contentType),
          itemId: itemId,
          method: method,
        ),
      );

  void logSelectContent({
    required String itemId,
    required AnalyticsContentType contentType,
  }) =>
      _runIfAnalyticsEnabled(
        () => _analytics.logSelectContent(
          contentType: enumToString(contentType),
          itemId: itemId,
        ),
      );
}
