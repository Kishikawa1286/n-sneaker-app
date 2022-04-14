import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/generate_firebase_auth_error_message.dart';
import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/account/account_repository.dart';

final signInPageViewModelProvider =
    AutoDisposeChangeNotifierProvider<SignInPageViewModel>(
  (ref) => SignInPageViewModel(ref.read(accountRepositoryProvider)),
);

class SignInPageViewModel extends ViewModelChangeNotifier {
  SignInPageViewModel(this._accountRepository);

  final AccountRepository _accountRepository;

  final TextEditingController _emailController = TextEditingController();

  TextEditingController get emailController => _emailController;

  bool _processing = false;

  bool get processing => _processing;

  Future<String> sendPasswordResetEmail() async {
    if (_processing) {
      return '';
    }
    _processing = true;
    notifyListeners();
    try {
      await _accountRepository.sendPasswordResetEmail(_emailController.text);
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
    return 'パスワード再設定のメールを送信しました。';
  }
}
