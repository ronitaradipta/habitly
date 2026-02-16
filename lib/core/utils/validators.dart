class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

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

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

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
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult({required this.isValid, this.errorMessage});

  factory ValidationResult.success() => const ValidationResult(isValid: true);

  factory ValidationResult.error(String message) => ValidationResult(
    isValid: false,
    errorMessage: message,
  );
}
