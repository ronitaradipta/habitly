import 'package:habitly/domain/entities/ai_insight.dart';
import 'package:habitly/domain/entities/analytics_range.dart';
import 'package:habitly/domain/entities/analytics_summary.dart';
import 'package:habitly/domain/entities/habit.dart';

abstract class AiInsightsRepository {
  Future<List<AiInsight>> generateInsights({
    required List<Habit> habits,
    required AnalyticsRange range,
    required AnalyticsSummary summary,
  });
}
