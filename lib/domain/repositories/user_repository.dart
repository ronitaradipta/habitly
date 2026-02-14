import 'package:habitly/domain/entities/user.dart';

abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<User?> getRegisteredUser(String email);
  Future<void> saveCurrentUser(User user);
  Future<void> saveRegisteredUser(User user);
  Future<void> removeCurrentUser();
  Future<bool> isEmailRegistered(String email);
}
