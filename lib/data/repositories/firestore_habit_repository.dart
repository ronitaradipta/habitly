import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitly/data/datasources/habit_datasource.dart';
import 'package:habitly/data/models/habit_model.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class FirestoreHabitRepository implements HabitRepository {
  final HabitDatasource _datasource;
  final FirebaseAuth _auth;

  FirestoreHabitRepository({
    required HabitDatasource datasource,
    FirebaseAuth? auth,
  }) : _datasource = datasource,
       _auth = auth ?? FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  @override
  Future<List<Habit>> getHabits() async {
    final uid = _uid;
    if (uid == null) return [];

    final models = await _datasource.getHabits(uid);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Habit>> getHabitsByDate(DateTime date) async {
    final uid = _uid;
    if (uid == null) return [];

    final models = await _datasource.getHabitsByDate(uid, date);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Habit?> getHabitById(String id) async {
    final uid = _uid;
    if (uid == null) return null;

    final model = await _datasource.getHabitById(uid, id);
    return model?.toEntity();
  }

  @override
  Future<void> addHabit(Habit habit) async {
    final uid = _uid;
    if (uid == null) throw Exception('User not logged in');

    await _datasource.addHabit(uid, HabitModel.fromEntity(habit));
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    final uid = _uid;
    if (uid == null) throw Exception('User not logged in');

    await _datasource.updateHabit(uid, HabitModel.fromEntity(habit));
  }

  @override
  Future<void> deleteHabit(String id) async {
    final uid = _uid;
    if (uid == null) throw Exception('User not logged in');

    await _datasource.deleteHabit(uid, id);
  }
}
