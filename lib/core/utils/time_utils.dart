import 'package:flutter/material.dart';

/// Centralized time formatting and parsing utilities.
class TimeUtils {
  TimeUtils._();

  /// Formats a [TimeOfDay] as "HH:mm" for storage (e.g. "07:00").
  static String formatForStorage(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Formats a [TimeOfDay] as "h:mm AM/PM" for display (e.g. "7:00 AM").
  static String formatForDisplay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Parses a "HH:mm" string into a [TimeOfDay]. Returns null on failure.
  static TimeOfDay? parse(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }
}
