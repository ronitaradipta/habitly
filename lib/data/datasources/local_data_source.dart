import 'package:habitly/data/models/habit_model.dart';
import 'package:habitly/data/models/user_model.dart';

abstract class LocalDataSource {
  Future<UserModel?> getCurrentUser();
  Future<void> saveCurrentUser(UserModel user);
  Future<void> removeCurrentUser();
  Future<UserModel?> getRegisteredUser(String email);
  Future<void> saveRegisteredUser(UserModel user);
  Future<bool> isEmailRegistered(String email);
  Future<List<HabitModel>> getHabits(String userEmail);
  Future<void> saveHabits(String userEmail, List<HabitModel> habits);
  Future<String> getTheme();
  Future<void> saveTheme(String themeModeName);
}
