import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:habitly/data/datasources/user_datasource.dart';
import 'package:habitly/data/models/user_model.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/repositories/user_repository.dart';

class FirestoreUserRepository implements UserRepository {
  final UserDatasource _datasource;
  final firebase_auth.FirebaseAuth _auth;

  FirestoreUserRepository({
    required UserDatasource datasource,
    firebase_auth.FirebaseAuth? auth,
  }) : _datasource = datasource,
       _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  @override
  Future<User?> getCurrentUser() async {
    final uid = _uid;
    if (uid == null) return null;

    final model = await _datasource.getCurrentUser(uid);
    return model?.toEntity();
  }

  @override
  Future<User?> getRegisteredUser(String email) async {
    final model = await _datasource.getUserByEmail(email);
    return model?.toEntity();
  }

  @override
  Future<void> saveUser(User user) async {
    final uid = _uid;
    if (uid == null) throw Exception('User not logged in');

    await _datasource.saveUser(uid, UserModel.fromEntity(user));
  }

  @override
  Future<bool> isEmailRegistered(String email) async {
    return await _datasource.isEmailRegistered(email);
  }
}
