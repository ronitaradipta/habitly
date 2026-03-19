import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitly/domain/entities/chat_message.dart';

class ChatMessageModel {
  final String role;
  final String content;
  final DateTime timestamp;

  const ChatMessageModel({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessageModel.fromEntity(ChatMessage entity) => ChatMessageModel(
    role: entity.role,
    content: entity.content,
    timestamp: entity.timestamp,
  );

  ChatMessage toEntity() => ChatMessage(
    role: role,
    content: content,
    timestamp: timestamp,
  );

  Map<String, dynamic> toFirestore() => {
    'role': role,
    'content': content,
    'timestamp': Timestamp.fromDate(timestamp),
  };

  factory ChatMessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    final data = doc.data()!;
    return ChatMessageModel(
      role: data['role'] as String,
      content: data['content'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
