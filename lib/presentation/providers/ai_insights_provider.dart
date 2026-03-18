import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/ai_insight.dart';
import 'package:habitly/domain/entities/analytics_range.dart';
import 'package:habitly/domain/entities/analytics_summary.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/usecases/generate_ai_insights_use_case.dart';
import 'package:habitly/presentation/providers/analytics_provider.dart';
import 'package:habitly/presentation/providers/use_case_providers.dart';

class AiInsightsNotifier extends AsyncNotifier<List<AiInsight>> {
  GenerateAiInsightsUseCase get _useCase =>
      ref.read(generateAiInsightsUseCaseProvider);

  @override
  Future<List<AiInsight>> build() {
    // Watch analytics range — reset to empty when range changes
    ref.watch(analyticsRangeProvider);
    return Future.value([]);
  }

  Future<void> generateInsights(
    List<Habit> habits,
    AnalyticsRange range,
    AnalyticsSummary summary,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _useCase(habits: habits, range: range, summary: summary),
    );
  }
}

final aiInsightsProvider =
    AsyncNotifierProvider<AiInsightsNotifier, List<AiInsight>>(
      AiInsightsNotifier.new,
    );
