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
  bool isCompleted;
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'iconCodePoint': iconCodePoint,
    'isCompleted': isCompleted,
    'completionTime': completionTime,
    'reminderPeriod': reminderPeriod?.name,
    'targetDate': targetDate?.toIso8601String(),
  };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'] as String,
    name: json['name'] as String,
    iconCodePoint: json['iconCodePoint'] as int? ?? 0xe8d8,
    isCompleted: json['isCompleted'] as bool? ?? false,
    completionTime: json['completionTime'] as String?,
    reminderPeriod: ReminderPeriodExtension.fromId(
      json['reminderPeriod'] as String?,
    ),
    targetDate: json['targetDate'] != null
        ? DateTime.parse(json['targetDate'] as String)
        : null,
  );

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
