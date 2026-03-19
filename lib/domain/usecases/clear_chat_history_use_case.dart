import 'package:habitly/domain/repositories/chat_history_repository.dart';

class ClearChatHistoryUseCase {
  final ChatHistoryRepository _repository;

  ClearChatHistoryUseCase(this._repository);

  Future<void> call() => _repository.clearMessages();
}
