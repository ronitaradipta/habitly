import 'package:habitly/domain/entities/chat_message.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';

typedef CreateHabitCallback = Future<void> Function({
  required String name,
  required String iconName,
  required DateTime targetDate,
  String? categoryId,
  HabitFrequency frequency,
  bool hasReminder,
  String? reminderTime,
});

abstract class AiChatRepository {
  Future<String> sendMessage({
    required String message,
    required List<ChatMessage> history,
    required List<Habit> habits,
    CreateHabitCallback? onCreateHabit,
    void Function(String)? onToolStatus,
  });
}
