import 'package:habitly/core/utils/date_utils.dart';
import 'package:habitly/core/utils/habit_schedule_utils.dart';
import 'package:habitly/domain/entities/analytics_data.dart';
import 'package:habitly/domain/entities/analytics_range.dart';
import 'package:habitly/domain/entities/analytics_summary.dart';
import 'package:habitly/domain/entities/daily_analytics_point.dart';
import 'package:habitly/domain/entities/habit.dart';

AnalyticsData buildAnalyticsData({
  required List<Habit> habits,
  required AnalyticsRange range,
  DateTime? now,
}) {
  final today = AppDateUtils.toDateOnly(now ?? DateTime.now());
  final startDate = today.subtract(Duration(days: range.days - 1));

  final points = List.generate(range.days, (index) {
    final date = startDate.add(Duration(days: index));
    var scheduledCount = 0;
    var completedCount = 0;

    for (final habit in habits) {
      if (!isHabitScheduledOnDate(habit, date)) continue;
      scheduledCount += 1;
      if (habit.isCompletedForDate(date)) {
        completedCount += 1;
      }
    }

    return DailyAnalyticsPoint(
      date: date,
      scheduledCount: scheduledCount,
      completedCount: completedCount,
    );
  });

  final activePoints =
      points.where((point) => point.scheduledCount > 0).toList();
  final totalScheduled = points.fold<int>(
    0,
    (sum, point) => sum + point.scheduledCount,
  );
  final totalCompleted = points.fold<int>(
    0,
    (sum, point) => sum + point.completedCount,
  );

  final avgCompletionRate = activePoints.isEmpty
      ? 0.0
      : activePoints
                .map((point) => point.completionRate ?? 0.0)
                .reduce((a, b) => a + b) /
            activePoints.length;

  final perfectDays = activePoints.where((point) => point.isPerfect).length;
  final bestStreak = _calculateBestStreak(points);
  final currentStreak = _calculateCurrentStreak(points);

  return AnalyticsData(
    range: range,
    points: points,
    summary: AnalyticsSummary(
      avgCompletionRate: avgCompletionRate,
      perfectDays: perfectDays,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      totalCompleted: totalCompleted,
      totalScheduled: totalScheduled,
    ),
  );
}

int _calculateBestStreak(List<DailyAnalyticsPoint> points) {
  var best = 0;
  var current = 0;

  for (final point in points) {
    if (point.scheduledCount == 0) continue;

    if (point.isPerfect) {
      current += 1;
      if (current > best) {
        best = current;
      }
    } else {
      current = 0;
    }
  }

  return best;
}

int _calculateCurrentStreak(List<DailyAnalyticsPoint> points) {
  var current = 0;

  for (final point in points.reversed) {
    if (point.scheduledCount == 0) continue;

    if (point.isPerfect) {
      current += 1;
      continue;
    }

    break;
  }

  return current;
}

String getMotivationalMessage(int percentage) {
  if (percentage == 0) {
    return 'Start your journey!';
  } else if (percentage < 50) {
    return 'Keep going, you\'re doing great!';
  } else if (percentage < 100) {
    return 'Almost there, stay strong!';
  } else {
    return 'Perfect! All habits completed! \u{1f389}';
  }
}
