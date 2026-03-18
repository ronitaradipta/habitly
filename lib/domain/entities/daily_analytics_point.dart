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
