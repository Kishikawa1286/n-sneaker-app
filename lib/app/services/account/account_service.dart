import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/account/account_model.dart';
import '../../repositories/account/account_repository.dart';
import '../../repositories/adapty/adapty_repository.dart';

final accountServiceProvider = Provider<AccountService>(
  (ref) => AccountService(
    ref.read(accountRepositoryProvider),
    ref.read(adaptyRepositoryProvider),
  ),
);

class AccountService {
  AccountService(
    this._accountRepository,
    this._adaptyRepository,
  ) {
    _authStateController.add(AuthState.notChecked);
    _signInWithSavedEmailAndPassword();
  }

  final AccountRepository _accountRepository;
  final AdaptyRepository _adaptyRepository;

  final StreamController<AuthState?> _authStateController =
      StreamController<AuthState?>();

  AccountModel? _account;

  AccountModel? get account => _account;
  Stream<AuthState?> get authStateStream => _authStateController.stream;

  void dispose() {
    _authStateController.close();
  }

  Future<void> _signInWithSavedEmailAndPassword() async {
    final isSavedEmailAndPassword =
        await _accountRepository.isSavedEmailAndPassword();
    if (!isSavedEmailAndPassword) {
      // ログイン情報がない
      _authStateController.add(AuthState.signOut);
      return;
    }
    try {
      final ac = await _accountRepository.signInWithSavedEmailAndPassword();
      _account = ac;
      await _adaptyRepository.identify(ac.id);
      _authStateController.add(AuthState.signIn);
    } on Exception catch (e) {
      print(e);
      // 保存されているものからメールアドレス・パスワードが変わった
      // オフライン時など
      _authStateController.add(AuthState.signOut);
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final ac = await _accountRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      _account = ac;
      await _adaptyRepository.identify(ac.id);
      _authStateController.add(AuthState.signIn);
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final ac = await _accountRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _account = ac;
      await _adaptyRepository.identify(ac.id);
      _authStateController.add(AuthState.signIn);
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _accountRepository.signOut();
      _account = null;
      await _adaptyRepository.logout();
      _authStateController.add(AuthState.signOut);
    } on Exception catch (e) {
      print(e);
    }
  }
}

enum AuthState { notChecked, signIn, signOut }
