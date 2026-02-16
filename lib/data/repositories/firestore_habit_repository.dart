import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitly/data/models/habit_model.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class FirestoreHabitRepository implements HabitRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirestoreHabitRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<HabitModel> _habitsRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('habits')
        .withConverter<HabitModel>(
          fromFirestore: HabitModel.fromFirestore,
          toFirestore: (model, _) => model.toFirestore(),
        );
  }

  @override
  Future<List<Habit>> getHabits() async {
    final uid = _uid;
    if (uid == null) return [];

    final snapshot = await _habitsRef(uid).get();
    return snapshot.docs.map((doc) => doc.data().toEntity()).toList();
  }

  @override
  Future<List<Habit>> getHabitsByDate(DateTime date) async {
    final uid = _uid;
    if (uid == null) return [];

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _habitsRef(uid)
        .where(
          'targetDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('targetDate', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    return snapshot.docs.map((doc) => doc.data().toEntity()).toList();
  }

  @override
  Future<Habit?> getHabitById(String id) async {
    final uid = _uid;
    if (uid == null) return null;

    final doc = await _habitsRef(uid).doc(id).get();
    return doc.data()?.toEntity();
  }

  @override
  Future<void> addHabit(Habit habit) async {
    final uid = _uid;
    if (uid == null) throw Exception('User not logged in');

    final docRef = _habitsRef(uid).doc();
    await docRef.set(HabitModel.fromEntity(habit));
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    final uid = _uid;
    if (uid == null) throw Exception('User not logged in');

    await _habitsRef(
      uid,
    ).doc(habit.id).set(HabitModel.fromEntity(habit), SetOptions(merge: true));
  }

  @override
  Future<void> deleteHabit(String id) async {
    final uid = _uid;
    if (uid == null) throw Exception('User not logged in');

    await _habitsRef(uid).doc(id).delete();
  }
}
