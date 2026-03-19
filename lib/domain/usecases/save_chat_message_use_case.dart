import 'package:habitly/domain/entities/chat_message.dart';
import 'package:habitly/domain/repositories/chat_history_repository.dart';

class SaveChatMessageUseCase {
  final ChatHistoryRepository _repository;

  SaveChatMessageUseCase(this._repository);

  Future<void> call(ChatMessage message) => _repository.addMessage(message);
}
