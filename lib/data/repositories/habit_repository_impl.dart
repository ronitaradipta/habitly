import 'package:habitly/data/datasources/local_data_source.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final LocalDataSource _localDataSource;
  final String _userEmail;

  List<Habit> _habits = [];

  HabitRepositoryImpl(this._localDataSource, this._userEmail);

  @override
  Future<void> loadFromStorage() async {
    _habits = await _localDataSource.getHabits(_userEmail);
  }

  @override
  Future<List<Habit>> getHabits() async {
    if (_habits.isEmpty) {
      await loadFromStorage();
    }
    return _habits;
  }

  @override
  Future<List<Habit>> getHabitsByDate(DateTime date) async {
    final allHabits = await getHabits();
    return allHabits.where((habit) {
      if (habit.targetDate == null) return false;
      return habit.targetDate!.year == date.year &&
          habit.targetDate!.month == date.month &&
          habit.targetDate!.day == date.day;
    }).toList();
  }

  @override
  Future<Habit?> getHabitById(String id) async {
    final allHabits = await getHabits();
    for (final habit in allHabits) {
      if (habit.id == id) return habit;
    }
    return null;
  }

  @override
  Future<void> addHabit(Habit habit) async {
    _habits = [..._habits, habit];
    await _localDataSource.saveHabits(_userEmail, _habits);
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    _habits = [
      for (final h in _habits)
        if (h.id == habit.id) habit else h,
    ];
    await _localDataSource.saveHabits(_userEmail, _habits);
  }

  @override
  Future<void> deleteHabit(String id) async {
    _habits = _habits.where((h) => h.id != id).toList();
    await _localDataSource.saveHabits(_userEmail, _habits);
  }
}
