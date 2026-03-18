import 'package:habitly/domain/entities/chat_message.dart';
import 'package:habitly/domain/entities/habit.dart';

abstract class AiChatRepository {
  Future<String> sendMessage({
    required String message,
    required List<ChatMessage> history,
    required List<Habit> habits,
  });
}
