import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitly/data/models/habit_model.dart';

abstract class HabitDatasource {
  Future<List<HabitModel>> getHabits(String uid);
  Future<List<HabitModel>> getHabitsByDate(String uid, DateTime date);
  Future<HabitModel?> getHabitById(String uid, String id);
  Future<void> addHabit(String uid, HabitModel habit);
  Future<void> updateHabit(String uid, HabitModel habit);
  Future<void> deleteHabit(String uid, String id);
}

class FirestoreHabitDatasource implements HabitDatasource {
  final FirebaseFirestore _firestore;

  FirestoreHabitDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

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
  Future<List<HabitModel>> getHabits(String uid) async {
    final snapshot = await _habitsRef(uid).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<List<HabitModel>> getHabitsByDate(String uid, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _habitsRef(uid)
        .where(
          'targetDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('targetDate', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<HabitModel?> getHabitById(String uid, String id) async {
    final doc = await _habitsRef(uid).doc(id).get();
    return doc.data();
  }

  @override
  Future<void> addHabit(String uid, HabitModel habit) async {
    final docRef = _habitsRef(uid).doc();
    final habitWithId = HabitModel(
      id: docRef.id,
      name: habit.name,
      iconCodePoint: habit.iconCodePoint,
      isCompleted: habit.isCompleted,
      completionTime: habit.completionTime,
      reminderPeriodName: habit.reminderPeriodName,
      targetDate: habit.targetDate,
    );
    await docRef.set(habitWithId);
  }

  @override
  Future<void> updateHabit(String uid, HabitModel habit) async {
    await _habitsRef(uid).doc(habit.id).set(habit, SetOptions(merge: true));
  }

  @override
  Future<void> deleteHabit(String uid, String id) async {
    await _habitsRef(uid).doc(id).delete();
  }
}
