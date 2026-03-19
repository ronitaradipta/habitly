import 'package:habitly/domain/entities/chat_message.dart';

abstract class ChatHistoryRepository {
  Future<List<ChatMessage>> getMessages();
  Future<void> addMessage(ChatMessage message);
  Future<void> clearMessages();
}
