import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/generate_firebase_auth_error_message.dart';
import '../../../utils/view_model_change_notifier.dart';
import '../../services/account/account_service.dart';

final signUpPageViewModelProvider =
    AutoDisposeChangeNotifierProvider<SignUpPageViewModel>(
  (ref) => SignUpPageViewModel(ref.watch(accountServiceProvider)),
);

class SignUpPageViewModel extends ViewModelChangeNotifier {
  SignUpPageViewModel(this._accountService);

  final AccountService _accountService;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  bool _consentToTermOfService = false;
  bool _consentToPrivacyPolicy = false;
  bool _processing = false;

  bool get consentToTermOfService => _consentToTermOfService;
  bool get consentToPrivacyPolicy => _consentToPrivacyPolicy;
  bool get consentToAllTerms =>
      _consentToTermOfService && _consentToPrivacyPolicy;
  bool get showSignInWithAppleButton => Platform.isIOS;
  bool get processing => _processing;

  void toggleAll() {
    if (_consentToTermOfService && _consentToPrivacyPolicy) {
      _consentToTermOfService = false;
      _consentToPrivacyPolicy = false;
    } else {
      _consentToTermOfService = true;
      _consentToPrivacyPolicy = true;
    }
    notifyListeners();
  }

  void toggleConsentToTermOfService() {
    if (_consentToTermOfService) {
      _consentToTermOfService = false;
    } else {
      _consentToTermOfService = true;
    }
    notifyListeners();
  }

  void toggleConsentToPrivacyPolicy() {
    if (_consentToPrivacyPolicy) {
      _consentToPrivacyPolicy = false;
    } else {
      _consentToPrivacyPolicy = true;
    }
    notifyListeners();
  }

  Future<String> signInWithEmailAndPassword() async {
    if (_processing) {
      return '';
    }
    if (!_consentToTermOfService || !_consentToPrivacyPolicy) {
      return '定款を読んで同意してください';
    }
    _processing = true;
    notifyListeners();
    try {
      await _accountService.createNewWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      _processing = false;
      notifyListeners();
      return generateFirebaseAuthErrorMessage(e);
    } on Exception catch (e) {
      print(e);
    }
    _processing = false;
    notifyListeners();
    return '';
  }

  Future<String> signInWithApple() async {
    if (_processing) {
      return '';
    }
    if (!_consentToTermOfService || !_consentToPrivacyPolicy) {
      return '定款を読んで同意してください';
    }
    _processing = true;
    notifyListeners();
    try {
      await _accountService.signInWithApple();
    } on Exception catch (e) {
      print(e);
    }
    _processing = false;
    notifyListeners();
    return '';
  }

  Future<String> signInWithGoogle() async {
    if (_processing) {
      return '';
    }
    if (!_consentToTermOfService || !_consentToPrivacyPolicy) {
      return '定款を読んで同意してください';
    }
    _processing = true;
    notifyListeners();
    try {
      await _accountService.signInWithGoogle();
    } on Exception catch (e) {
      print(e);
    }
    _processing = false;
    notifyListeners();
    return '';
  }
}
