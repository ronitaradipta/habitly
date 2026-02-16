import 'package:habitly/domain/entities/user.dart';

abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<User?> getRegisteredUser(String email);
  Future<void> saveUser(User user);
  Future<bool> isEmailRegistered(String email);
}
