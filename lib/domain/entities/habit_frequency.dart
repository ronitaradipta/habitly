import 'package:flutter/material.dart';

enum HabitFrequency {
  hourly,
  daily,
  weekly,
  monthly,
  customDays;

  static HabitFrequency fromName(String? name) {
    if (name == null) return HabitFrequency.daily;
    return HabitFrequency.values.firstWhere(
      (e) => e.name == name,
      orElse: () => HabitFrequency.daily,
    );
  }

  String get displayName {
    switch (this) {
      case HabitFrequency.hourly:
        return 'Hourly';
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.monthly:
        return 'Monthly';
      case HabitFrequency.customDays:
        return 'Custom';
    }
  }

  String get description {
    switch (this) {
      case HabitFrequency.hourly:
        return 'Repeat every hour';
      case HabitFrequency.daily:
        return 'Repeat every day';
      case HabitFrequency.weekly:
        return 'Repeat every week';
      case HabitFrequency.monthly:
        return 'Repeat every month';
      case HabitFrequency.customDays:
        return 'Repeat every N days';
    }
  }

  IconData get icon {
    switch (this) {
      case HabitFrequency.hourly:
        return Icons.schedule;
      case HabitFrequency.daily:
        return Icons.today;
      case HabitFrequency.weekly:
        return Icons.view_week;
      case HabitFrequency.monthly:
        return Icons.calendar_month;
      case HabitFrequency.customDays:
        return Icons.event_repeat;
    }
  }
}
