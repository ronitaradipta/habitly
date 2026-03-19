import 'package:habitly/data/datasources/auth_datasource.dart';
import 'package:habitly/data/datasources/chat_history_datasource.dart';
import 'package:habitly/data/models/chat_message_model.dart';
import 'package:habitly/domain/entities/chat_message.dart';
import 'package:habitly/domain/repositories/chat_history_repository.dart';

class FirestoreChatHistoryRepository implements ChatHistoryRepository {
  final ChatHistoryDatasource _datasource;
  final AuthDatasource _authDatasource;

  FirestoreChatHistoryRepository({
    required ChatHistoryDatasource datasource,
    required AuthDatasource authDatasource,
  }) : _datasource = datasource,
       _authDatasource = authDatasource;

  String? get _uid => _authDatasource.currentUserId;

  @override
  Future<List<ChatMessage>> getMessages() async {
    final uid = _uid;
    if (uid == null) return [];
    final models = await _datasource.getMessages(uid);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addMessage(ChatMessage message) async {
    final uid = _uid;
    if (uid == null) return;
    await _datasource.addMessage(uid, ChatMessageModel.fromEntity(message));
  }

  @override
  Future<void> clearMessages() async {
    final uid = _uid;
    if (uid == null) return;
    await _datasource.clearMessages(uid);
  }
}
