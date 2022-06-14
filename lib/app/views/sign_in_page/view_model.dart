import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/generate_firebase_auth_error_message.dart';
import '../../../utils/view_model_change_notifier.dart';
import '../../services/account/account_service.dart';

final signInPageViewModelProvider =
    AutoDisposeChangeNotifierProvider<SignInPageViewModel>(
  (ref) => SignInPageViewModel(ref.watch(accountServiceProvider)),
);

class SignInPageViewModel extends ViewModelChangeNotifier {
  SignInPageViewModel(this._accountService);

  final AccountService _accountService;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  bool _processing = false;

  bool get showSocialLoginButtons => Platform.isIOS;
  bool get processing => _processing;

  Future<String> signInWithEmailAndPassword() async {
    if (_processing) {
      return '';
    }
    _processing = true;
    notifyListeners();
    try {
      await _accountService.signInWithEmailAndPassword(
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
