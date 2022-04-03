import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import '../../interfaces/firebase/cloud_functions/cloud_functions_interface.dart';
import '../../interfaces/firebase/firebase_auth/firebase_auth_interface.dart';
import '../../interfaces/shared_preferences/shared_preferences_interface.dart';
import '../../interfaces/shared_preferences/shared_preferences_key.dart';
import 'account_model.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepository(
    ref.read(firebaseAuthInterfaceProvider),
    ref.read(cloudFirestoreInterfaceProvider),
    ref.read(cloudFunctionsInterfaceProvider),
    ref.read(sharedPreferencesInterfaceProvider),
  ),
);

class AccountRepository {
  const AccountRepository(
    this._firebaseAuthInterface,
    this._cloudFirestoreInterface,
    this._cloudFunctionsInterface,
    this._sharedPreferencesInterface,
  );

  final FirebaseAuthInterface _firebaseAuthInterface;
  final CloudFirestoreInterface _cloudFirestoreInterface;
  final CloudFunctionsInterface _cloudFunctionsInterface;
  final SharedPreferencesInterface _sharedPreferencesInterface;

  User? getCurrentUser() => _firebaseAuthInterface.getCurrentUser();

  Future<bool> isSavedEmailAndPassword() async {
    final email = await _sharedPreferencesInterface
        .getString(SharedPreferencesKey.signInEmail);
    final password = await _sharedPreferencesInterface
        .getString(SharedPreferencesKey.signInPassword);
    return email != null && password != null;
  }

  void _saveEmailAndPassword({
    required String email,
    required String password,
  }) {
    _sharedPreferencesInterface.setString(
      key: SharedPreferencesKey.signInEmail,
      value: email,
    );
    _sharedPreferencesInterface.setString(
      key: SharedPreferencesKey.signInPassword,
      value: password,
    );
  }

  Future<AccountModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Firebase Authでログインを試みる
      // 未登録ならば新規作成される
      final userCredential =
          await _firebaseAuthInterface.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = userCredential.user?.uid;
      // nullになるのは例外のとき
      // userIdをString?からStringにするためのコード
      if (userId == null) {
        throw Exception('uid is null. something went wrong.');
      }
      final dynamic result = await _cloudFunctionsInterface.createAccount();
      print('createAccount result: $result');
      _saveEmailAndPassword(email: email, password: password);
      return AccountModel(
        id: userId,
        numberOfCollectionProducts: 0,
        createdAt: Timestamp.now(),
        lastEditedAt: Timestamp.now(),
      );
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<AccountModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Firebase Authでログインを試みる
      // 未登録ならば新規作成される
      final userCredential =
          await _firebaseAuthInterface.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = userCredential.user?.uid;
      // nullになるのは例外のとき
      // userIdをString?からStringにするためのコード
      if (userId == null) {
        throw Exception('uid is null. something went wrong.');
      }
      final documentSnapshot =
          await _cloudFirestoreInterface.fetchDocumentSnapshot(
        documentPath: accountDocumentPath(userId),
      );
      _saveEmailAndPassword(email: email, password: password);
      return AccountModel.fromDocumentSnapshot(
        snapshot: documentSnapshot,
        email: email,
      );
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<AccountModel> signInWithSavedEmailAndPassword() async {
    try {
      final email = await _sharedPreferencesInterface
          .getString(SharedPreferencesKey.signInEmail);
      final password = await _sharedPreferencesInterface
          .getString(SharedPreferencesKey.signInPassword);
      if (email == null || password == null) {
        throw Exception('email and password are not saved.');
      }
      return signInWithEmailAndPassword(email: email, password: password);
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) =>
      _firebaseAuthInterface.sendPasswordResetEmail(email: email);

  Future<void> signOut() async {
    await _firebaseAuthInterface.signOut();
    await _sharedPreferencesInterface
        .removeString(SharedPreferencesKey.signInEmail);
    await _sharedPreferencesInterface
        .removeString(SharedPreferencesKey.signInPassword);
  }
}
