import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitly/core/utils/time_utils.dart';

void main() {
  group('TimeUtils.formatForStorage', () {
    test('formats hour and minute using zero padding', () {
      const time = TimeOfDay(hour: 7, minute: 5);
      expect(TimeUtils.formatForStorage(time), '07:05');
    });
  });

  group('TimeUtils.formatForDisplay', () {
    test('formats midnight as 12:xx AM', () {
      const time = TimeOfDay(hour: 0, minute: 5);
      expect(TimeUtils.formatForDisplay(time), '12:05 AM');
    });

    test('formats afternoon as PM with 12-hour clock', () {
      const time = TimeOfDay(hour: 14, minute: 30);
      expect(TimeUtils.formatForDisplay(time), '2:30 PM');
    });
  });

  group('TimeUtils.parse', () {
    test('parses valid HH:mm string', () {
      final parsed = TimeUtils.parse('07:05');
      expect(parsed, isNotNull);
      expect(parsed!.hour, 7);
      expect(parsed.minute, 5);
    });

    test('returns null for invalid separator', () {
      expect(TimeUtils.parse('07-05'), isNull);
    });

    test('returns null for non-numeric values', () {
      expect(TimeUtils.parse('ab:cd'), isNull);
    });
  });
}
