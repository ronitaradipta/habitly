import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitly/data/models/user_model.dart';

abstract class UserDatasource {
  Future<UserModel?> getCurrentUser(String uid);
  Future<UserModel?> getUserByEmail(String email);
  Future<void> saveUser(String uid, UserModel user);
  Future<bool> isEmailRegistered(String email);
}

class FirestoreUserDatasource implements UserDatasource {
  final FirebaseFirestore _firestore;

  FirestoreUserDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<UserModel> get _usersRef {
    return _firestore
        .collection('users')
        .withConverter<UserModel>(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (model, _) => model.toFirestore(),
        );
  }

  @override
  Future<UserModel?> getCurrentUser(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    return doc.data();
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    final snapshot = await _usersRef
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  @override
  Future<void> saveUser(String uid, UserModel user) async {
    await _usersRef.doc(uid).set(user, SetOptions(merge: true));
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
