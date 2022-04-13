import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import '../../interfaces/firebase/cloud_functions/cloud_functions_interface.dart';
import '../../interfaces/firebase/firebase_auth/firebase_auth_interface.dart';
import 'account_model.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepository(
    ref.read(firebaseAuthInterfaceProvider),
    ref.read(cloudFirestoreInterfaceProvider),
    ref.read(cloudFunctionsInterfaceProvider),
  ),
);

class AccountRepository {
  const AccountRepository(
    this._firebaseAuthInterface,
    this._cloudFirestoreInterface,
    this._cloudFunctionsInterface,
  );

  final FirebaseAuthInterface _firebaseAuthInterface;
  final CloudFirestoreInterface _cloudFirestoreInterface;
  final CloudFunctionsInterface _cloudFunctionsInterface;

  User? getCurrentUser() => _firebaseAuthInterface.getCurrentUser();

  void setOnStateChanged({
    required void Function() onSignedOut,
    required void Function(User) onSignedIn,
  }) =>
      _firebaseAuthInterface.setOnStateChanged(
        onSignedOut: onSignedOut,
        onSignedIn: onSignedIn,
      );

  Future<String> signInWithApple() async {
    final userCredential = await _firebaseAuthInterface.signInWithApple();
    final uid = userCredential.user?.uid;
    // nullになるのは例外のとき
    // uidをString?からStringにするためのコード
    if (uid == null) {
      throw Exception('uid is null. something went wrong.');
    }
    return uid;
  }

  Future<String> signInWithGoogle() async {
    final userCredential = await _firebaseAuthInterface.signInWithGoogle();
    final uid = userCredential.user?.uid;
    // nullになるのは例外のとき
    // uidをString?からStringにするためのコード
    if (uid == null) {
      throw Exception('uid is null. something went wrong.');
    }
    return uid;
  }

  Future<AccountModel?> fetch(String uid) async {
    final documentSnapshot =
        await _cloudFirestoreInterface.fetchDocumentSnapshot(
      documentPath: accountDocumentPath(uid),
    );
    if (documentSnapshot.exists) {
      return AccountModel.fromDocumentSnapshot(snapshot: documentSnapshot);
    }
    return null; // 未登録
  }

  Future<AccountModel> createNew(String uid) async {
    final dynamic result = await _cloudFunctionsInterface.createAccount();
    print('createAccount result: $result');
    return AccountModel(
      id: uid,
      numberOfCollectionProducts: 1,
      createdAt: Timestamp.now(),
      lastEditedAt: Timestamp.now(),
    );
  }

  Future<void> signOut() => _firebaseAuthInterface.signOut();
}
