import 'package:flutter_test/flutter_test.dart';
import 'package:habitly/core/utils/validators.dart';

void main() {
  group('Validators.validateEmail', () {
    test('returns required error when email is null or empty', () {
      expect(Validators.validateEmail(null), 'Email is required');
      expect(Validators.validateEmail('   '), 'Email is required');
    });

    test('returns format error for invalid email', () {
      expect(
        Validators.validateEmail('invalid-email'),
        'Please enter a valid email',
      );
    });

    test('returns null for valid email with extra spaces', () {
      expect(Validators.validateEmail('  test@example.com  '), isNull);
    });
  });

  group('Validators.validatePassword', () {
    test('returns required error when password is empty', () {
      expect(Validators.validatePassword(''), 'Password is required');
    });

    test('returns min length error based on custom minLength', () {
      expect(
        Validators.validatePassword('1234567', minLength: 8),
        'Password must be at least 8 characters',
      );
    });

    test('returns null when password meets minimum length', () {
      expect(Validators.validatePassword('123456'), isNull);
    });
  });

  group('Validators.validateConfirmPassword', () {
    test('returns error when confirmation is empty', () {
      expect(
        Validators.validateConfirmPassword('', '123456'),
        'Please confirm your password',
      );
    });

    test('returns mismatch error when passwords differ', () {
      expect(
        Validators.validateConfirmPassword('abcdef', '123456'),
        'Passwords do not match',
      );
    });

    test('returns null when passwords match', () {
      expect(Validators.validateConfirmPassword('123456', '123456'), isNull);
    });
  });

  group('Validators mobile and helper methods', () {
    test('validateMobile checks empty and min digits', () {
      expect(Validators.validateMobile(null), 'Mobile number is required');
      expect(
        Validators.validateMobile('1234567'),
        'Mobile number must be at least 8 digits',
      );
      expect(Validators.validateMobile(' 12345678 '), isNull);
    });

    test('isValid helpers return expected boolean', () {
      expect(Validators.isValidEmail('test@example.com'), isTrue);
      expect(Validators.isValidEmail('bad-email'), isFalse);
      expect(Validators.isValidMobile('12345678'), isTrue);
      expect(Validators.isValidMobile('1234'), isFalse);
      expect(Validators.isValidPassword('123456'), isTrue);
      expect(Validators.isValidPassword('12345'), isFalse);
    });
  });
}
