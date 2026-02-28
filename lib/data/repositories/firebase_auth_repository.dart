import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:habitly/core/utils/auth_error_mapper.dart';
import 'package:habitly/data/datasources/auth_datasource.dart';
import 'package:habitly/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final AuthDatasource _datasource;

  FirebaseAuthRepository({required AuthDatasource datasource})
    : _datasource = datasource;

  @override
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _datasource.signUp(email: email, password: password);
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
      return await _datasource.signIn(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(AuthErrorMapper.mapException(e));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _datasource.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(AuthErrorMapper.mapException(e));
    }
  }

  @override
  String? get currentUserId => _datasource.currentUserId;

  @override
  Stream<String?> get authStateChanges => _datasource.authStateChanges;
}
