import 'package:flutter_test/flutter_test.dart';
import 'package:habitly/core/utils/analytics_calculator.dart';
import 'package:habitly/domain/entities/analytics_range.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';

void main() {
  group('buildAnalyticsData', () {
    test('calculates completion metrics for mixed frequencies', () {
      final habits = [
        Habit(
          id: 'daily',
          name: 'Daily Read',
          iconName: 'school',
          frequency: HabitFrequency.daily,
          targetDate: DateTime(2026, 3, 1),
          completedDates: {
            '2026-03-01': true,
            '2026-03-02': true,
            '2026-03-04': true,
            '2026-03-07': true,
          },
        ),
        Habit(
          id: 'weekly',
          name: 'Weekly Review',
          iconName: 'work',
          frequency: HabitFrequency.weekly,
          targetDate: DateTime(2026, 3, 2), // Monday
          completedDates: {'2026-03-02': true},
        ),
        Habit(
          id: 'custom',
          name: 'Deep Work',
          iconName: 'task_alt',
          frequency: HabitFrequency.customDays,
          customDays: 2,
          targetDate: DateTime(2026, 3, 1),
          completedDates: {'2026-03-01': true, '2026-03-05': true},
        ),
      ];

      final data = buildAnalyticsData(
        habits: habits,
        range: AnalyticsRange.last7,
        now: DateTime(2026, 3, 7),
      );

      expect(data.points.length, 7);
      expect(data.summary.totalScheduled, 12);
      expect(data.summary.totalCompleted, 7);
      expect(data.summary.avgCompletionRate, closeTo(4 / 7, 0.0001));
      expect(data.summary.perfectDays, 3);
      expect(data.summary.bestStreak, 2);
      expect(data.summary.currentStreak, 0);
    });

    test('uses null completion rate for no-schedule days', () {
      final habits = [
        Habit(
          id: 'weekly',
          name: 'Weekly Cleanup',
          iconName: 'home',
          frequency: HabitFrequency.weekly,
          targetDate: DateTime(2026, 3, 2), // Monday
          completedDates: {'2026-03-02': true},
        ),
      ];

      final data = buildAnalyticsData(
        habits: habits,
        range: AnalyticsRange.last7,
        now: DateTime(2026, 3, 7),
      );

      final mondayPoint = data.points.firstWhere(
        (point) => point.date == DateTime(2026, 3, 2),
      );
      final tuesdayPoint = data.points.firstWhere(
        (point) => point.date == DateTime(2026, 3, 3),
      );

      expect(mondayPoint.completionRate, 1.0);
      expect(tuesdayPoint.completionRate, isNull);
      expect(data.summary.avgCompletionRate, 1.0);
    });

    test('current streak ignores trailing no-schedule days', () {
      final habits = [
        Habit(
          id: 'weekly',
          name: 'Weekly Reflection',
          iconName: 'school',
          frequency: HabitFrequency.weekly,
          targetDate: DateTime(2026, 3, 5), // Thursday
          completedDates: {'2026-03-05': true},
        ),
      ];

      final data = buildAnalyticsData(
        habits: habits,
        range: AnalyticsRange.last7,
        now: DateTime(2026, 3, 10),
      );

      expect(data.summary.currentStreak, 1);
      expect(data.summary.bestStreak, 1);
      expect(data.summary.totalScheduled, 1);
      expect(data.hasScheduledData, isTrue);
    });

    test('returns empty summary when there are no scheduled habits', () {
      final habits = [
        Habit(
          id: 'future',
          name: 'Future habit',
          iconName: 'school',
          frequency: HabitFrequency.daily,
          targetDate: DateTime(2026, 4, 1),
        ),
      ];

      final data = buildAnalyticsData(
        habits: habits,
        range: AnalyticsRange.last7,
        now: DateTime(2026, 3, 7),
      );

      expect(data.summary.totalScheduled, 0);
      expect(data.summary.totalCompleted, 0);
      expect(data.summary.avgCompletionRate, 0);
      expect(data.summary.currentStreak, 0);
      expect(data.summary.bestStreak, 0);
      expect(data.hasScheduledData, isFalse);
    });
  });
}
