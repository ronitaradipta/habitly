import 'package:habitly/core/utils/validators.dart';
import 'package:habitly/domain/entities/habit.dart';

class HabitValidators {
  HabitValidators._();

  static ValidationResult validateHabitName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.error('Please enter a habit name');
    }
    if (value.trim().length > 100) {
      return ValidationResult.error(
        'Habit name must be less than 100 characters',
      );
    }
    return ValidationResult.success();
  }

  static ValidationResult validateHabitDate(DateTime? value) {
    if (value == null) {
      return ValidationResult.error('Please select a date');
    }
    return ValidationResult.success();
  }

  static ValidationResult validateHabitPeriod(ReminderPeriod? value) {
    if (value == null) {
      return ValidationResult.error('Please select a reminder period');
    }
    return ValidationResult.success();
  }
}
