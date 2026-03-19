import 'package:habitly/domain/entities/chat_message.dart';
import 'package:habitly/domain/repositories/chat_history_repository.dart';

class GetChatHistoryUseCase {
  final ChatHistoryRepository _repository;

  GetChatHistoryUseCase(this._repository);

  Future<List<ChatMessage>> call() => _repository.getMessages();
}
