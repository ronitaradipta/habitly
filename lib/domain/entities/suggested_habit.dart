import 'package:habitly/domain/entities/category.dart';

class SuggestedHabit {
  final String name;
  final String categoryId;
  final String frequency;
  final String? reminderTime;
  final String reason;

  const SuggestedHabit({
    required this.name,
    required this.categoryId,
    required this.frequency,
    this.reminderTime,
    required this.reason,
  });

  String get iconName =>
      HabitCategory.fromId(categoryId)?.iconName ?? 'interests';

  factory SuggestedHabit.fromJson(Map<String, dynamic> json) {
    return SuggestedHabit(
      name: json['name'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? 'other',
      frequency: json['frequency'] as String? ?? 'daily',
      reminderTime: json['reminderTime'] as String?,
      reason: json['reason'] as String? ?? '',
    );
  }
}
