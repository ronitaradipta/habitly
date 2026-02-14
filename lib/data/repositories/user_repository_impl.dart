import 'package:habitly/data/datasources/local_data_source.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final LocalDataSource _localDataSource;

  UserRepositoryImpl(this._localDataSource);

  @override
  Future<User?> getCurrentUser() {
    return _localDataSource.getCurrentUser();
  }

  @override
  Future<User?> getRegisteredUser(String email) {
    return _localDataSource.getRegisteredUser(email);
  }

  @override
  Future<void> saveCurrentUser(User user) {
    return _localDataSource.saveCurrentUser(user);
  }

  @override
  Future<void> saveRegisteredUser(User user) {
    return _localDataSource.saveRegisteredUser(user);
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
