import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class AuthDatasource {
  Future<String> signUp({required String email, required String password});
  Future<String> signIn({required String email, required String password});
  Future<void> signOut();
  String? get currentUserId;
  Stream<String?> get authStateChanges;
}

class FirebaseAuthDatasource implements AuthDatasource {
  final firebase_auth.FirebaseAuth _auth;

  FirebaseAuthDatasource({firebase_auth.FirebaseAuth? auth})
    : _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  @override
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!.uid;
  }

  @override
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!.uid;
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
