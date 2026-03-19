import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitly/data/models/chat_message_model.dart';

abstract class ChatHistoryDatasource {
  Future<List<ChatMessageModel>> getMessages(String uid);
  Future<void> addMessage(String uid, ChatMessageModel message);
  Future<void> clearMessages(String uid);
}

class FirestoreChatHistoryDatasource implements ChatHistoryDatasource {
  final FirebaseFirestore _firestore;

  FirestoreChatHistoryDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<ChatMessageModel> _messagesRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('chat_messages')
        .withConverter<ChatMessageModel>(
          fromFirestore: ChatMessageModel.fromFirestore,
          toFirestore: (model, _) => model.toFirestore(),
        );
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String uid) async {
    final snapshot =
        await _messagesRef(uid).orderBy('timestamp', descending: false).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> addMessage(String uid, ChatMessageModel message) async {
    await _messagesRef(uid).add(message);
  }

  @override
  Future<void> clearMessages(String uid) async {
    final snapshot = await _messagesRef(uid).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
