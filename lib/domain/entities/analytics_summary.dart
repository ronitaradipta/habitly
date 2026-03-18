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
