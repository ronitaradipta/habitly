enum ReminderPeriod { morning, noon, evening }

extension ReminderPeriodExtension on ReminderPeriod {
  String get time {
    switch (this) {
      case ReminderPeriod.morning:
        return '7:00 AM';
      case ReminderPeriod.noon:
        return '1:00 PM';
      case ReminderPeriod.evening:
        return '7:00 PM';
    }
  }

  String get label {
    switch (this) {
      case ReminderPeriod.morning:
        return 'Morning';
      case ReminderPeriod.noon:
        return 'Noon';
      case ReminderPeriod.evening:
        return 'Evening';
    }
  }

  String get id => name;

  static ReminderPeriod? fromId(String? id) {
    switch (id) {
      case 'morning':
        return ReminderPeriod.morning;
      case 'noon':
        return ReminderPeriod.noon;
      case 'evening':
        return ReminderPeriod.evening;
      default:
        return null;
    }
  }
}

class Habit {
  final String id;
  final String name;
  final int iconCodePoint;
  final bool isCompleted;
  final String? completionTime;
  final ReminderPeriod? reminderPeriod;
  final DateTime? targetDate;

  Habit({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    this.isCompleted = false,
    this.completionTime,
    this.reminderPeriod,
    this.targetDate,
  });

  Habit copyWith({
    String? id,
    String? name,
    int? iconCodePoint,
    bool? isCompleted,
    String? completionTime,
    ReminderPeriod? reminderPeriod,
    DateTime? targetDate,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      isCompleted: isCompleted ?? this.isCompleted,
      completionTime: completionTime ?? this.completionTime,
      reminderPeriod: reminderPeriod ?? this.reminderPeriod,
      targetDate: targetDate ?? this.targetDate,
    );
  }
}
