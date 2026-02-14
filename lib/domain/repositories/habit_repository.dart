import 'package:habitly/domain/entities/habit.dart';

abstract class HabitRepository {
  Future<List<Habit>> getHabits();
  Future<List<Habit>> getHabitsByDate(DateTime date);
  Future<Habit?> getHabitById(String id);
  Future<void> addHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(String id);
  Future<void> loadFromStorage();
}
