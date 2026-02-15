import 'package:habitly/core/utils/date_utils.dart';
import 'package:habitly/data/datasources/local_data_source.dart';
import 'package:habitly/data/models/habit_model.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final LocalDataSource _localDataSource;
  final String _userEmail;

  List<Habit> _habits = [];

  HabitRepositoryImpl(this._localDataSource, this._userEmail);

  Future<void> loadFromStorage() async {
    final models = await _localDataSource.getHabits(_userEmail);
    _habits = models.map((m) => m.toEntity()).toList();
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
      return AppDateUtils.isSameDay(habit.targetDate!, date);
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
    await _saveToStorage();
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    _habits = [
      for (final h in _habits)
        if (h.id == habit.id) habit else h,
    ];
    await _saveToStorage();
  }

  @override
  Future<void> deleteHabit(String id) async {
    _habits = _habits.where((h) => h.id != id).toList();
    await _saveToStorage();
  }

  Future<void> _saveToStorage() async {
    final models = _habits.map((h) => HabitModel.fromEntity(h)).toList();
    await _localDataSource.saveHabits(_userEmail, models);
  }
}
