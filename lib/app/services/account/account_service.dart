import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/account/account_model.dart';
import '../../repositories/account/account_repository.dart';
import '../../repositories/adapty/adapty_repository.dart';
import '../../repositories/product_glb_file/product_glb_file_repository.dart';

final accountServiceProvider = Provider<AccountService>(
  (ref) => AccountService(
    ref.read(accountRepositoryProvider),
    ref.read(adaptyRepositoryProvider),
    ref.read(productGlbFileRepositoryProvider),
  ),
);

class AccountService {
  AccountService(
    this._accountRepository,
    this._adaptyRepository,
    this._productGlbFileRepository,
  ) {
    _authStateController.add(AuthState.notChecked);
    _accountRepository.setOnStateChanged(
      onSignedOut: () {
        _authStateController.add(AuthState.signOut);
        print('not logged in.');
      },
      onSignedIn: _onSignedIn,
    );
  }

  final AccountRepository _accountRepository;
  final AdaptyRepository _adaptyRepository;
  final ProductGlbFileRepository _productGlbFileRepository;

  final StreamController<AuthState?> _authStateController =
      StreamController<AuthState?>();

  AccountModel? _account;

  AccountModel? get account => _account;
  Stream<AuthState?> get authStateStream => _authStateController.stream;

  void dispose() {
    _authStateController.close();
  }

  Future<void> _onSignedIn(User user) async {
    final uid = user.uid;
    if (_account != null) {
      return;
    }
    try {
      final ac = await _accountRepository.fetch(uid);
      if (ac == null) {
        _authStateController.add(AuthState.signOut);
        return;
      }
      _account = ac;

      await _adaptyRepository.identify(uid);
      await _accountRepository.updateData();

      // ログボ関連処理
      /*
      if (_canGetPoint(ac.lastSignedInAt.toDate())) {
        _account = AccountModel(
          id: ac.id,
          numberOfCollectionProducts: ac.numberOfCollectionProducts,
          createdAt: ac.createdAt,
          lastEditedAt: Timestamp.now(),
          point: ac.point + 1,
          lastSignedInAt: Timestamp.now(),
        );
        _authStateController.add(AuthState.signInAndGetPoint);
        return;
      }
      */

      _authStateController.add(AuthState.signIn);
    } on Exception catch (e) {
      print(e);
      // 削除されたアカウントの認証情報がローカルにある場合
      if (e.toString().contains('PERMISSION_DENIED')) {
        await signOut();
      }
      _authStateController.add(AuthState.signOut);
    }
  }

  /*
  bool _canGetPoint(DateTime lastSignedInAt) {
    final now = Timestamp.now().toDate();
    if (lastSignedInAt.year > now.year) {
      return false;
    }
    if (lastSignedInAt.year < now.year) {
      return true;
    }
    if (lastSignedInAt.month > now.month) {
      return false;
    }
    if (lastSignedInAt.month < now.month) {
      return true;
    }
    if (lastSignedInAt.day < now.day) {
      return true;
    }
    return false;
  }
  */

  Future<void> createNewWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // 一度クリアする
      _account = null;
      await _adaptyRepository.logout();
      await _productGlbFileRepository.removeLastUsedGlbFileId();
      final ac = await _accountRepository.createNewWithEmailAndPassword(
        email: email,
        password: password,
      );
      _account = ac;
      _authStateController.add(AuthState.signInWithNewAccount);
      await _adaptyRepository.identify(ac.id);
    } on Exception catch (e) {
      print(e);
      _authStateController.add(AuthState.signOut);
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // ローカルのデータをリセット
    try {
      _account = null;
      await _adaptyRepository.logout();
      await _productGlbFileRepository.removeLastUsedGlbFileId();
    } on Exception catch (e) {
      print(e);
      _authStateController.add(AuthState.signOut);
      return;
    }
    // ログイン試行
    try {
      final uid = await _accountRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final ac = await _accountRepository.fetch(uid);
      if (ac == null) {
        _authStateController.add(AuthState.signOut);
        return;
      }
      _account = ac;
      await _adaptyRepository.identify(uid);
      _authStateController.add(AuthState.signIn);
    } on Exception catch (e) {
      print(e);
      _authStateController.add(AuthState.signOut);
      rethrow;
    }
  }

  Future<void> _signInWithUidGetter(
    Future<String> Function() signInToFirebaseAuth,
  ) async {
    // ローカルのデータをリセット
    try {
      _account = null;
      await _adaptyRepository.logout();
      await _productGlbFileRepository.removeLastUsedGlbFileId();
    } on Exception catch (e) {
      print(e);
      _authStateController.add(AuthState.signOut);
      return;
    }
    // ログイン試行
    try {
      final uid = await signInToFirebaseAuth();
      final ac = await _accountRepository.fetch(uid);
      if (ac == null) {
        _authStateController.add(AuthState.signOut);
        return;
      }
      // 既存アカウント
      _account = ac;
      await _adaptyRepository.identify(uid);
      _authStateController.add(AuthState.signIn);
      return;
    } on Exception catch (e) {
      print(e);
      try {
        // 新規登録
        final uid = await signInToFirebaseAuth();
        _account = await _accountRepository.createNewWithUid(uid);
        await _adaptyRepository.identify(uid);
        _authStateController.add(AuthState.signInWithNewAccount);
        return;
      } on Exception catch (e) {
        print(e);
      }
      _authStateController.add(AuthState.signOut);
    }
  }

  Future<void> signInWithApple() =>
      _signInWithUidGetter(_accountRepository.signInWithApple);

  Future<void> signInWithGoogle() =>
      _signInWithUidGetter(_accountRepository.signInWithGoogle);

  Future<void> signOut() async {
    try {
      await _accountRepository.signOut();
      _account = null;
      _authStateController.add(AuthState.signOut);
      await _productGlbFileRepository.removeLastUsedGlbFileId();
      await _adaptyRepository.logout();
    } on Exception catch (e) {
      print(e);
    }
  }
}

enum AuthState { notChecked, signIn, signInWithNewAccount, signOut }
