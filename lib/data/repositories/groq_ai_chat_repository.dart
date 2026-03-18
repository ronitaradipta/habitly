import 'package:habitly/core/services/ai_chat_service.dart';
import 'package:habitly/domain/entities/chat_message.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/ai_chat_repository.dart';

class GroqAiChatRepository implements AiChatRepository {
  final AiChatService _service;

  GroqAiChatRepository(this._service);

  @override
  Future<String> sendMessage({
    required String message,
    required List<ChatMessage> history,
    required List<Habit> habits,
  }) =>
      _service.sendMessage(message: message, history: history, habits: habits);
}
