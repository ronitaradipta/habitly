abstract class AuthRepository {
  Future<String> signUp({required String email, required String password});
  Future<String> signIn({required String email, required String password});
  Future<void> signOut();
  String? get currentUserId;
  Stream<String?> get authStateChanges;
}
