import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitly/domain/repositories/theme_repository.dart';

class FirestoreThemeRepository implements ThemeRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirestoreThemeRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  DocumentReference<Map<String, dynamic>> _settingsDoc(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('theme');
  }

  @override
  Future<String> getTheme() async {
    final uid = _uid;
    if (uid == null) return 'system';

    try {
      final doc = await _settingsDoc(uid).get();
      if (!doc.exists) return 'system';
      return doc.data()?['themeMode'] as String? ?? 'system';
    } catch (e) {
      return 'system';
    }
  }

  @override
  Future<void> saveTheme(String themeModeName) async {
    final uid = _uid;
    if (uid == null) return;

    await _settingsDoc(
      uid,
    ).set({'themeMode': themeModeName}, SetOptions(merge: true));
  }
}
