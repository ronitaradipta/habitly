import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:habitly/core/utils/auth_error_mapper.dart';
import 'package:habitly/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final firebase_auth.FirebaseAuth _auth;

  FirebaseAuthRepository({firebase_auth.FirebaseAuth? auth})
    : _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  @override
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!.uid;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(AuthErrorMapper.mapException(e));
    }
  }

  @override
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!.uid;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(AuthErrorMapper.mapException(e));
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  Stream<String?> get authStateChanges =>
      _auth.authStateChanges().map((user) => user?.uid);
}
