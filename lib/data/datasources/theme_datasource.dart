import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ThemeDatasource {
  Future<String> getTheme(String uid);
  Future<void> saveTheme(String uid, String themeModeName);
}

class FirestoreThemeDatasource implements ThemeDatasource {
  final FirebaseFirestore _firestore;

  FirestoreThemeDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _settingsDoc(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('theme');
  }

  @override
  Future<String> getTheme(String uid) async {
    try {
      final doc = await _settingsDoc(uid).get();
      if (!doc.exists) return 'system';
      return doc.data()?['themeMode'] as String? ?? 'system';
    } catch (e) {
      return 'system';
    }
  }

  @override
  Future<void> saveTheme(String uid, String themeModeName) async {
    await _settingsDoc(uid).set(
      {'themeMode': themeModeName},
      SetOptions(merge: true),
    );
  }
}
