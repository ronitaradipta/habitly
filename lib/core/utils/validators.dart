import 'package:habitly/domain/entities/habit.dart';

class Validators {
  Validators._();

  // Email validation regex pattern
  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // Validates an email address
  // Returns null if valid, error message if invalid
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return _emailRegex.hasMatch(email);
  }

  // Returns null if valid, error message if invalid
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Returns null if valid, error message if invalid
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  // Returns null if valid, error message if invalid
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Returns null if valid, error message if invalid
  static String? validateMobile(String? value, {int minDigits = 8}) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    if (value.trim().length < minDigits) {
      return 'Mobile number must be at least $minDigits digits';
    }
    return null;
  }

  static bool isValidMobile(String mobile, {int minDigits = 8}) {
    return mobile.isNotEmpty && mobile.length >= minDigits;
  }

  static bool isValidPassword(String password, {int minLength = 6}) {
    return password.length >= minLength;
  }

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

enum ValidationSeverity { error, warning, info }

class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final ValidationSeverity severity;

  const ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.severity = ValidationSeverity.error,
  });

  factory ValidationResult.success() => const ValidationResult(isValid: true);

  factory ValidationResult.error(String message) => ValidationResult(
    isValid: false,
    errorMessage: message,
    severity: ValidationSeverity.error,
  );

  factory ValidationResult.warning(String message) => ValidationResult(
    isValid: true,
    errorMessage: message,
    severity: ValidationSeverity.warning,
  );
}
