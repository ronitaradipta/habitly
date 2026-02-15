import 'package:flutter/foundation.dart';
import 'package:habitly/data/datasources/local_data_source.dart';
import 'package:habitly/data/models/habit_model.dart';
import 'package:habitly/data/models/user_model.dart';
import 'package:habitly/infrastructure/hive_service.dart';
import 'package:habitly/infrastructure/hive_constants.dart';

class HiveDataSource implements LocalDataSource {
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final box = await HiveService.instance.getBox(HiveConstants.authBox);
      return box.get(HiveConstants.userKey) as UserModel?;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  @override
  Future<void> saveCurrentUser(UserModel user) async {
    final box = await HiveService.instance.getBox(HiveConstants.authBox);
    await box.put(HiveConstants.userKey, user);
  }

  @override
  Future<void> removeCurrentUser() async {
    final box = await HiveService.instance.getBox(HiveConstants.authBox);
    await box.delete(HiveConstants.userKey);
  }

  @override
  Future<UserModel?> getRegisteredUser(String email) async {
    final box = await HiveService.instance.getBox(
      HiveConstants.registeredUsersBox,
    );
    final key = HiveConstants.registeredUserKey(email.toLowerCase());
    return box.get(key) as UserModel?;
  }

  @override
  Future<void> saveRegisteredUser(UserModel user) async {
    final box = await HiveService.instance.getBox(
      HiveConstants.registeredUsersBox,
    );
    final key = HiveConstants.registeredUserKey(user.email.toLowerCase());
    await box.put(key, user);
  }

  @override
  Future<bool> isEmailRegistered(String email) async {
    final box = await HiveService.instance.getBox(
      HiveConstants.registeredUsersBox,
    );
    final key = HiveConstants.registeredUserKey(email.toLowerCase());
    return box.containsKey(key);
  }

  @override
  Future<List<HabitModel>> getHabits(String userEmail) async {
    try {
      final box = await HiveService.instance.getBox(HiveConstants.habitBox);
      final key = HiveConstants.habitListKeyForUser(userEmail);
      final habitsDynamic = box.get(key, defaultValue: <HabitModel>[]);

      if (habitsDynamic is! List) {
        debugPrint(
          'Hive type mismatch: expected List, got ${habitsDynamic.runtimeType}',
        );
        return [];
      }

      return List<HabitModel>.from(habitsDynamic);
    } catch (e) {
      debugPrint('Error loading habits from Hive: $e');
      return [];
    }
  }

  @override
  Future<void> saveHabits(String userEmail, List<HabitModel> habits) async {
    final box = await HiveService.instance.getBox(HiveConstants.habitBox);
    final key = HiveConstants.habitListKeyForUser(userEmail);
    await box.put(key, habits);
  }

  @override
  Future<String> getTheme() async {
    try {
      final box = await HiveService.instance.getBox(HiveConstants.themeBox);
      return box.get(HiveConstants.themeKey, defaultValue: 'system') as String;
    } catch (e) {
      debugPrint('Error getting theme from Hive: $e');
      return 'system';
    }
  }

  @override
  Future<void> saveTheme(String themeModeName) async {
    try {
      final box = await HiveService.instance.getBox(HiveConstants.themeBox);
      await box.put(HiveConstants.themeKey, themeModeName);
    } catch (e) {
      debugPrint('Error saving theme to Hive: $e');
    }
  }
}
