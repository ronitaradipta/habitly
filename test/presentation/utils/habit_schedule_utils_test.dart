import 'package:flutter_test/flutter_test.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:habitly/presentation/utils/habit_schedule_utils.dart';

void main() {
  group('isHabitScheduledOnDate', () {
    test('returns false when targetDate is null', () {
      final habit = Habit(id: '1', name: 'Read', iconName: 'school');

      expect(isHabitScheduledOnDate(habit, DateTime(2026, 3, 1)), isFalse);
    });

    test('daily habit is active from start date until end date', () {
      final habit = Habit(
        id: '1',
        name: 'Read',
        iconName: 'school',
        frequency: HabitFrequency.daily,
        targetDate: DateTime(2026, 3, 10),
        endDate: DateTime(2026, 3, 20),
      );

      expect(isHabitScheduledOnDate(habit, DateTime(2026, 3, 9)), isFalse);
      expect(isHabitScheduledOnDate(habit, DateTime(2026, 3, 10)), isTrue);
      expect(isHabitScheduledOnDate(habit, DateTime(2026, 3, 18)), isTrue);
      expect(isHabitScheduledOnDate(habit, DateTime(2026, 3, 21)), isFalse);
    });

    test('weekly habit is active only on the same weekday as start', () {
      final habit = Habit(
        id: '1',
        name: 'Run',
        iconName: 'fitness_center',
        frequency: HabitFrequency.weekly,
        targetDate: DateTime(2026, 3, 2), // Monday
      );

      expect(
        isHabitScheduledOnDate(habit, DateTime(2026, 3, 9)),
        isTrue,
      ); // Monday
      expect(
        isHabitScheduledOnDate(habit, DateTime(2026, 3, 10)),
        isFalse,
      ); // Tuesday
    });

    test('monthly habit handles short month fallback to end of month', () {
      final habit = Habit(
        id: '1',
        name: 'Budget',
        iconName: 'attach_money',
        frequency: HabitFrequency.monthly,
        targetDate: DateTime(2026, 1, 31),
      );

      expect(isHabitScheduledOnDate(habit, DateTime(2026, 2, 28)), isTrue);
      expect(isHabitScheduledOnDate(habit, DateTime(2026, 2, 27)), isFalse);
      expect(isHabitScheduledOnDate(habit, DateTime(2026, 3, 31)), isTrue);
    });

    test('customDays habit repeats at configured interval', () {
      final habit = Habit(
        id: '1',
        name: 'Deep work',
        iconName: 'work',
        frequency: HabitFrequency.customDays,
        customDays: 3,
        targetDate: DateTime(2026, 3, 1),
      );

      expect(isHabitScheduledOnDate(habit, DateTime(2026, 3, 1)), isTrue);
      expect(isHabitScheduledOnDate(habit, DateTime(2026, 3, 2)), isFalse);
      expect(isHabitScheduledOnDate(habit, DateTime(2026, 3, 4)), isTrue);
      expect(isHabitScheduledOnDate(habit, DateTime(2026, 3, 7)), isTrue);
    });
  });
}
