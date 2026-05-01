import 'package:habitly/domain/entities/chat_message.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/ai_chat_repository.dart';

class SendChatMessageUseCase {
  final AiChatRepository _repository;

  SendChatMessageUseCase(this._repository);

  Future<String> call({
    required String message,
    required List<ChatMessage> history,
    required List<Habit> habits,
    CreateHabitCallback? onCreateHabit,
    void Function(String)? onToolStatus,
  }) =>
      _repository.sendMessage(
        message: message,
        history: history,
        habits: habits,
        onCreateHabit: onCreateHabit,
        onToolStatus: onToolStatus,
      );
}
