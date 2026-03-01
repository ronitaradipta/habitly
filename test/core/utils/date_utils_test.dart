import 'package:flutter_test/flutter_test.dart';
import 'package:habitly/core/utils/date_utils.dart';

void main() {
  group('AppDateUtils.isSameDay', () {
    test('returns true for same calendar date with different times', () {
      final morning = DateTime(2026, 3, 1, 8, 0);
      final evening = DateTime(2026, 3, 1, 20, 30);

      expect(AppDateUtils.isSameDay(morning, evening), isTrue);
    });

    test('returns false for different calendar dates', () {
      final first = DateTime(2026, 3, 1);
      final second = DateTime(2026, 3, 2);

      expect(AppDateUtils.isSameDay(first, second), isFalse);
    });
  });

  group('AppDateUtils.formatDateLabel', () {
    test('returns Today for current date', () {
      final today = DateTime.now();
      expect(AppDateUtils.formatDateLabel(today), 'Today');
    });

    test('returns formatted date for non-current date', () {
      final date = DateTime(2024, 1, 1);
      expect(AppDateUtils.formatDateLabel(date), 'Jan 1, 2024');
    });
  });
}
