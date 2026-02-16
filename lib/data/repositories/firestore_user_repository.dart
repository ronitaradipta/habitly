import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:habitly/data/models/user_model.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/repositories/user_repository.dart';

class FirestoreUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

  FirestoreUserRepository({
    FirebaseFirestore? firestore,
    firebase_auth.FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<UserModel> get _usersRef {
    return _firestore
        .collection('users')
        .withConverter<UserModel>(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (model, _) => model.toFirestore(),
        );
  }

  @override
  Future<User?> getCurrentUser() async {
    final uid = _uid;
    if (uid == null) return null;

    final doc = await _usersRef.doc(uid).get();
    return doc.data()?.toEntity();
  }

  @override
  Future<User?> getRegisteredUser(String email) async {
    final snapshot = await _usersRef
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data().toEntity();
  }

  @override
  Future<void> saveUser(User user) async {
    final uid = _uid;
    if (uid == null) throw Exception('User not logged in');

    await _usersRef
        .doc(uid)
        .set(UserModel.fromEntity(user), SetOptions(merge: true));
  }

  @override
  Future<bool> isEmailRegistered(String email) async {
    final snapshot = await _usersRef
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }
}
