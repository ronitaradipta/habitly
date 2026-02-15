import 'package:habitly/data/datasources/local_data_source.dart';
import 'package:habitly/data/models/user_model.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final LocalDataSource _localDataSource;

  UserRepositoryImpl(this._localDataSource);

  @override
  Future<User?> getCurrentUser() async {
    final model = await _localDataSource.getCurrentUser();
    return model?.toEntity();
  }

  @override
  Future<User?> getRegisteredUser(String email) async {
    final model = await _localDataSource.getRegisteredUser(email);
    return model?.toEntity();
  }

  @override
  Future<void> saveCurrentUser(User user) {
    return _localDataSource.saveCurrentUser(UserModel.fromEntity(user));
  }

  @override
  Future<void> saveRegisteredUser(User user) {
    return _localDataSource.saveRegisteredUser(UserModel.fromEntity(user));
  }

  @override
  Future<void> removeCurrentUser() {
    return _localDataSource.removeCurrentUser();
  }

  @override
  Future<bool> isEmailRegistered(String email) {
    return _localDataSource.isEmailRegistered(email);
  }
}
