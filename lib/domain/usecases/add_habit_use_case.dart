import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class AddHabitUseCase {
  final HabitRepository _habitRepository;

  AddHabitUseCase(this._habitRepository);

  Future<void> call({
    required String name,
    required String iconName,
    required DateTime targetDate,
    bool hasReminder = false,
    String? reminderTime,
    String? categoryId,
    HabitFrequency frequency = HabitFrequency.daily,
    int? customDays,
    DateTime? endDate,
  }) async {
    final habit = Habit(
      id: '',
      name: name,
      iconName: iconName,
      targetDate: targetDate,
      hasReminder: hasReminder,
      reminderTime: reminderTime,
      categoryId: categoryId,
      frequency: frequency,
      customDays: customDays,
      endDate: endDate,
    );
    await _habitRepository.addHabit(habit);
  }
}
