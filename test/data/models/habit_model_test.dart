import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitly/data/models/habit_model.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';

void main() {
  group('HabitModel.fromEntity', () {
    test('maps entity fields into model', () {
      final entity = Habit(
        id: 'habit-1',
        name: 'Workout',
        iconName: 'fitness_center',
        targetDate: DateTime(2026, 3, 1),
        hasReminder: true,
        reminderTime: '07:00',
        categoryId: 'health',
        frequency: HabitFrequency.weekly,
        customDays: 2,
        endDate: DateTime(2026, 3, 31),
        completedDates: {'2026-03-01': true},
      );

      final model = HabitModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.name, entity.name);
      expect(model.iconName, entity.iconName);
      expect(model.frequencyName, 'weekly');
      expect(model.completedDates, {'2026-03-01': true});
    });
  });

  group('HabitModel.toEntity', () {
    test('uses daily as fallback frequency for unknown frequencyName', () {
      final model = HabitModel(
        id: 'habit-1',
        name: 'Workout',
        iconName: 'fitness_center',
        frequencyName: 'invalid-frequency',
      );

      final entity = model.toEntity();
      expect(entity.frequency, HabitFrequency.daily);
    });
  });

  group('HabitModel.toFirestore', () {
    test('serializes DateTime fields as Timestamp and keeps map fields', () {
      final model = HabitModel(
        id: 'habit-1',
        name: 'Workout',
        iconName: 'fitness_center',
        targetDate: DateTime(2026, 3, 1, 7, 0),
        hasReminder: true,
        reminderTime: '07:00',
        categoryId: 'health',
        frequencyName: 'daily',
        customDays: 2,
        endDate: DateTime(2026, 3, 31, 21, 30),
        completedDates: {'2026-03-01': true},
      );

      final firestoreMap = model.toFirestore();

      expect(firestoreMap['targetDate'], isA<Timestamp>());
      expect(
        (firestoreMap['targetDate'] as Timestamp).toDate(),
        model.targetDate,
      );
      expect(firestoreMap['endDate'], isA<Timestamp>());
      expect((firestoreMap['endDate'] as Timestamp).toDate(), model.endDate);
      expect(firestoreMap['completedDates'], {'2026-03-01': true});
      expect(firestoreMap['frequencyName'], 'daily');
    });
  });
}
