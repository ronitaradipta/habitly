import 'package:habitly/domain/entities/user.dart';

abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<void> saveUser(User user);
  Future<bool> isEmailRegistered(String email);
}
