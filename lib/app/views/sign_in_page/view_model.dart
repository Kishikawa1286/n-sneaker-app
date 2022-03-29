import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/generate_firebase_auth_error_message.dart';
import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/account/account_repository.dart';
import '../../services/account/account_service.dart';

final signInPageViewModelProvider =
    ChangeNotifierProvider.autoDispose<SignInPageViewModel>(
  (ref) => SignInPageViewModel(
    ref.read(accountServiceProvider),
    ref.read(accountRepositoryProvider),
  ),
);

class SignInPageViewModel extends ViewModelChangeNotifier {
  SignInPageViewModel(this._accountService, this._accountRepository);

  final AccountService _accountService;
  final AccountRepository _accountRepository;

  final CarouselController _carouselController = CarouselController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  CarouselController get carouselController => _carouselController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  String _signInErrorMessage = '';
  String _signUpErrorMessage = '';
  String _passwordResetErrorMessage = '';
  int _carouselIndex = 0;

  String get signInErrorMessage => _signInErrorMessage;
  String get signUpErrorMessage => _signUpErrorMessage;
  String get passwordResetErrorMessage => _passwordResetErrorMessage;
  int get carouselIndex => _carouselIndex;

  void setCarouselIndex(int index) {
    _carouselIndex = index;
    notifyListeners();
  }

  Future<void> signIn() async {
    try {
      await _accountService.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      _signInErrorMessage = generateFirebaseAuthErrorMessage(e);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> signUp() async {
    try {
      await _accountService.signUpWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      _signUpErrorMessage = generateFirebaseAuthErrorMessage(e);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> sendPasswordResetEmail() async {
    try {
      await _accountRepository.sendPasswordResetEmail(
        email: _emailController.text,
      );
    } on FirebaseAuthException catch (e) {
      _passwordResetErrorMessage = generateFirebaseAuthErrorMessage(e);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
}
