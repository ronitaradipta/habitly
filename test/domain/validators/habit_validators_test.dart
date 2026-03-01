import 'package:flutter_test/flutter_test.dart';
import 'package:habitly/domain/validators/habit_validators.dart';

void main() {
  group('HabitValidators.validateHabitName', () {
    test('returns error when name is null or empty', () {
      final nullResult = HabitValidators.validateHabitName(null);
      final emptyResult = HabitValidators.validateHabitName('   ');

      expect(nullResult.isValid, isFalse);
      expect(nullResult.errorMessage, 'Please enter a habit name');
      expect(emptyResult.isValid, isFalse);
      expect(emptyResult.errorMessage, 'Please enter a habit name');
    });

    test('returns error when name is longer than 100 characters', () {
      final name = 'a' * 101;
      final result = HabitValidators.validateHabitName(name);

      expect(result.isValid, isFalse);
      expect(
        result.errorMessage,
        'Habit name must be less than 100 characters',
      );
    });

    test('returns success for valid habit name', () {
      final result = HabitValidators.validateHabitName('  Morning Run  ');
      expect(result.isValid, isTrue);
      expect(result.errorMessage, isNull);
    });
  });

  group('HabitValidators.validateHabitDate', () {
    test('returns error when date is null', () {
      final result = HabitValidators.validateHabitDate(null);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Please select a date');
    });

    test('returns success when date is provided', () {
      final result = HabitValidators.validateHabitDate(DateTime(2026, 3, 1));
      expect(result.isValid, isTrue);
    });
  });

  group('HabitValidators.validateEndDate', () {
    test('returns success when endDate is null', () {
      final result = HabitValidators.validateEndDate(
        null,
        DateTime(2026, 3, 1),
      );
      expect(result.isValid, isTrue);
    });

    test('returns error when endDate is before startDate', () {
      final result = HabitValidators.validateEndDate(
        DateTime(2026, 2, 28),
        DateTime(2026, 3, 1),
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'End date must be on or after start date');
    });

    test('returns success when endDate is same as startDate', () {
      final sameDay = DateTime(2026, 3, 1);
      final result = HabitValidators.validateEndDate(sameDay, sameDay);
      expect(result.isValid, isTrue);
    });
  });
}
