import 'package:habitly/data/datasources/auth_datasource.dart';
import 'package:habitly/data/datasources/user_datasource.dart';
import 'package:habitly/data/models/user_model.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/repositories/user_repository.dart';

class FirestoreUserRepository implements UserRepository {
  final UserDatasource _datasource;
  final AuthDatasource _authDatasource;

  FirestoreUserRepository({
    required UserDatasource datasource,
    required AuthDatasource authDatasource,
  }) : _datasource = datasource,
       _authDatasource = authDatasource;

  String? get _uid => _authDatasource.currentUserId;

  @override
  Future<User?> getCurrentUser() async {
    final uid = _uid;
    if (uid == null) return null;

    final model = await _datasource.getCurrentUser(uid);
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
