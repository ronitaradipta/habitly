import 'package:flutter/foundation.dart';
import 'package:habitly/data/datasources/local_data_source.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/infrastructure/hive_service.dart';
import 'package:habitly/infrastructure/hive_constants.dart';

class HiveDataSource implements LocalDataSource {
  @override
  Future<User?> getCurrentUser() async {
    try {
      final box = await HiveService.instance.getBox(HiveConstants.authBox);
      return box.get(HiveConstants.userKey) as User?;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  @override
  Future<void> saveCurrentUser(User user) async {
    final box = await HiveService.instance.getBox(HiveConstants.authBox);
    await box.put(HiveConstants.userKey, user);
  }

  @override
  Future<void> removeCurrentUser() async {
    final box = await HiveService.instance.getBox(HiveConstants.authBox);
    await box.delete(HiveConstants.userKey);
  }

  @override
  Future<User?> getRegisteredUser(String email) async {
    final box = await HiveService.instance.getBox(
      HiveConstants.registeredUsersBox,
    );
    final key = HiveConstants.registeredUserKey(email.toLowerCase());
    return box.get(key) as User?;
  }

  @override
  Future<void> saveRegisteredUser(User user) async {
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
  Future<List<Habit>> getHabits(String userEmail) async {
    try {
      final box = await HiveService.instance.getBox(HiveConstants.habitBox);
      final key = HiveConstants.habitListKeyForUser(userEmail);
      final habitsDynamic = box.get(key, defaultValue: <Habit>[]);

      if (habitsDynamic is! List) {
        debugPrint(
          'Hive type mismatch: expected List, got ${habitsDynamic.runtimeType}',
        );
        return [];
      }

      return List<Habit>.from(habitsDynamic);
    } catch (e) {
      debugPrint('Error loading habits from Hive: $e');
      return [];
    }
  }

  @override
  Future<void> saveHabits(String userEmail, List<Habit> habits) async {
    final box = await HiveService.instance.getBox(HiveConstants.habitBox);
    final key = HiveConstants.habitListKeyForUser(userEmail);
    await box.put(key, habits);
  }
}
