import 'package:flutter_test/flutter_test.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';

void main() {
  group('Habit.dateKey', () {
    test('creates yyyy-MM-dd key with zero padding', () {
      final key = Habit.dateKey(DateTime(2026, 3, 1));
      expect(key, '2026-03-01');
    });
  });

  group('Habit.isCompletedForDate', () {
    test('returns true only for completed date key', () {
      final habit = Habit(
        id: '1',
        name: 'Read',
        iconName: 'book',
        completedDates: {'2026-03-01': true},
      );

      expect(habit.isCompletedForDate(DateTime(2026, 3, 1)), isTrue);
      expect(habit.isCompletedForDate(DateTime(2026, 3, 2)), isFalse);
    });
  });

  group('Habit.formattedReminderTime', () {
    test('returns No reminder when reminder is disabled', () {
      final habit = Habit(id: '1', name: 'Read', iconName: 'book');
      expect(habit.formattedReminderTime, 'No reminder');
    });

    test('formats midnight reminder to AM string', () {
      final habit = Habit(
        id: '1',
        name: 'Read',
        iconName: 'book',
        hasReminder: true,
        reminderTime: '00:05',
      );
      expect(habit.formattedReminderTime, '12:05 AM');
    });

    test('formats afternoon reminder to PM string', () {
      final habit = Habit(
        id: '1',
        name: 'Read',
        iconName: 'book',
        hasReminder: true,
        reminderTime: '14:30',
      );
      expect(habit.formattedReminderTime, '2:30 PM');
    });
  });

  group('Habit.copyWith', () {
    test('preserves fields when value is not provided', () {
      final original = Habit(
        id: '1',
        name: 'Read',
        iconName: 'book',
        targetDate: DateTime(2026, 3, 1),
        hasReminder: true,
        reminderTime: '08:00',
        categoryId: 'health',
        frequency: HabitFrequency.customDays,
        customDays: 3,
        endDate: DateTime(2026, 3, 31),
      );

      final updated = original.copyWith(name: 'Read 20 pages');

      expect(updated.name, 'Read 20 pages');
      expect(updated.targetDate, original.targetDate);
      expect(updated.reminderTime, original.reminderTime);
      expect(updated.categoryId, original.categoryId);
      expect(updated.customDays, original.customDays);
      expect(updated.endDate, original.endDate);
    });

    test('allows explicitly setting nullable fields to null', () {
      final original = Habit(
        id: '1',
        name: 'Read',
        iconName: 'book',
        targetDate: DateTime(2026, 3, 1),
        hasReminder: true,
        reminderTime: '08:00',
        categoryId: 'health',
        frequency: HabitFrequency.customDays,
        customDays: 3,
        endDate: DateTime(2026, 3, 31),
      );

      final updated = original.copyWith(
        targetDate: null,
        reminderTime: null,
        categoryId: null,
        customDays: null,
        endDate: null,
      );

      expect(updated.targetDate, isNull);
      expect(updated.reminderTime, isNull);
      expect(updated.categoryId, isNull);
      expect(updated.customDays, isNull);
      expect(updated.endDate, isNull);
    });
  });
}
