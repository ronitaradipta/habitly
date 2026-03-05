import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/utils/habit_schedule_utils.dart';

enum AnalyticsRange {
  last7,
  last30,
  last90;

  int get days {
    switch (this) {
      case AnalyticsRange.last7:
        return 7;
      case AnalyticsRange.last30:
        return 30;
      case AnalyticsRange.last90:
        return 90;
    }
  }

  String get label {
    switch (this) {
      case AnalyticsRange.last7:
        return '7D';
      case AnalyticsRange.last30:
        return '30D';
      case AnalyticsRange.last90:
        return '90D';
    }
  }
}

class DailyAnalyticsPoint {
  final DateTime date;
  final int scheduledCount;
  final int completedCount;

  const DailyAnalyticsPoint({
    required this.date,
    required this.scheduledCount,
    required this.completedCount,
  });

  double? get completionRate {
    if (scheduledCount == 0) return null;
    return completedCount / scheduledCount;
  }

  bool get isPerfect => scheduledCount > 0 && completedCount == scheduledCount;
}

class AnalyticsSummary {
  final double avgCompletionRate;
  final int perfectDays;
  final int currentStreak;
  final int bestStreak;
  final int totalCompleted;
  final int totalScheduled;

  const AnalyticsSummary({
    required this.avgCompletionRate,
    required this.perfectDays,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalCompleted,
    required this.totalScheduled,
  });
}

class AnalyticsData {
  final AnalyticsRange range;
  final List<DailyAnalyticsPoint> points;
  final AnalyticsSummary summary;

  const AnalyticsData({
    required this.range,
    required this.points,
    required this.summary,
  });

  bool get hasScheduledData => summary.totalScheduled > 0;
}

class AnalyticsRangeNotifier extends Notifier<AnalyticsRange> {
  @override
  AnalyticsRange build() => AnalyticsRange.last30;

  void setRange(AnalyticsRange range) {
    state = range;
  }
}

final analyticsRangeProvider =
    NotifierProvider<AnalyticsRangeNotifier, AnalyticsRange>(
      AnalyticsRangeNotifier.new,
    );

final analyticsDataProvider = Provider<AsyncValue<AnalyticsData>>((ref) {
  final habitsAsync = ref.watch(habitProvider);
  final range = ref.watch(analyticsRangeProvider);

  return habitsAsync.whenData(
    (habits) => buildAnalyticsData(habits: habits, range: range),
  );
});

AnalyticsData buildAnalyticsData({
  required List<Habit> habits,
  required AnalyticsRange range,
  DateTime? now,
}) {
  final today = _toDateOnly(now ?? DateTime.now());
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

  final activePoints = points
      .where((point) => point.scheduledCount > 0)
      .toList();
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

DateTime _toDateOnly(DateTime date) =>
    DateTime(date.year, date.month, date.day);
