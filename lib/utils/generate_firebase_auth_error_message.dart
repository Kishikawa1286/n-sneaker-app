import 'package:firebase_auth/firebase_auth.dart';

String generateFirebaseAuthErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return '無効なメールアドレスです。';
    case 'wrong-password':
      return 'パスワードが違います。';
    case 'user-disabled':
      return 'アカウントが無効化されています。';
    case 'user-not-found':
      return 'アカウントが存在しません。';
    case 'operation-not-allowed':
      return '権限がありません。';
    case 'too-many-requests':
      return 'リクエスト数の上限に達しました。時間をおいて再度お試しください。';
    case 'email-already-exists':
      return 'そのメールアドレスはすでに登録されています。';
    case 'email-already-in-use':
      return 'そのメールアドレスはすでに登録されています。';
    default:
      return 'メールアドレス・パスワードを確認してください。';
  }
}
