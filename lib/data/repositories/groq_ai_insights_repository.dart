import 'package:habitly/core/services/ai_insights_service.dart';
import 'package:habitly/domain/entities/ai_insight.dart';
import 'package:habitly/domain/entities/analytics_range.dart';
import 'package:habitly/domain/entities/analytics_summary.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/ai_insights_repository.dart';

class GroqAiInsightsRepository implements AiInsightsRepository {
  final AiInsightsService _service;

  GroqAiInsightsRepository(this._service);

  @override
  Future<List<AiInsight>> generateInsights({
    required List<Habit> habits,
    required AnalyticsRange range,
    required AnalyticsSummary summary,
  }) =>
      _service.generateInsights(habits: habits, range: range, summary: summary);
}
