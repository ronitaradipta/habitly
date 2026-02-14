import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/user.dart';

abstract class LocalDataSource {
  Future<User?> getCurrentUser();
  Future<void> saveCurrentUser(User user);
  Future<void> removeCurrentUser();
  Future<User?> getRegisteredUser(String email);
  Future<void> saveRegisteredUser(User user);
  Future<bool> isEmailRegistered(String email);
  Future<List<Habit>> getHabits(String userEmail);
  Future<void> saveHabits(String userEmail, List<Habit> habits);
}
