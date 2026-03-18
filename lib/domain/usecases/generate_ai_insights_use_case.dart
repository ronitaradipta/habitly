import 'package:habitly/domain/entities/ai_insight.dart';
import 'package:habitly/domain/entities/analytics_range.dart';
import 'package:habitly/domain/entities/analytics_summary.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/ai_insights_repository.dart';

class GenerateAiInsightsUseCase {
  final AiInsightsRepository _repository;

  GenerateAiInsightsUseCase(this._repository);

  Future<List<AiInsight>> call({
    required List<Habit> habits,
    required AnalyticsRange range,
    required AnalyticsSummary summary,
  }) =>
      _repository.generateInsights(habits: habits, range: range, summary: summary);
}
