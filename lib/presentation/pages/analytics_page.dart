import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/providers/analytics_provider.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/utils/auth_listener.dart';
import 'package:habitly/presentation/widgets/analytics/ai_insights_card.dart';
import 'package:habitly/presentation/widgets/analytics/analytics_chart_card.dart';
import 'package:habitly/presentation/widgets/analytics/analytics_empty_state.dart';
import 'package:habitly/presentation/widgets/analytics/analytics_range_selector.dart';
import 'package:habitly/presentation/widgets/analytics/analytics_summary_grid.dart';
import 'package:habitly/presentation/widgets/analytics/completed_vs_scheduled_chart.dart';
import 'package:habitly/presentation/widgets/analytics/completion_rate_chart.dart';
import 'package:habitly/presentation/widgets/shared/navigation/bottom_nav_bar.dart';
import 'package:habitly/presentation/widgets/shared/navigation/custom_app_bar.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsDataProvider);
    final habitsAsync = ref.watch(habitProvider);

    listenForAuthRedirect(ref, context);

    return ThemeScaffold(
      showThemeButton: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(title: 'Analytics'),
          Expanded(
            child: analyticsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(
                child: Text('Error: $e', style: AppTextStyles.caption(context)),
              ),
              data: (data) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnalyticsRangeSelector(
                      selectedRange: data.range,
                      onChanged: (range) {
                        ref
                            .read(analyticsRangeProvider.notifier)
                            .setRange(range);
                      },
                    ),
                    const SizedBox(height: 16),
                    if (!data.hasScheduledData) ...[
                      const AnalyticsEmptyState(),
                    ] else ...[
                      AnalyticsSummaryGrid(summary: data.summary),
                      const SizedBox(height: 20),
                      AnalyticsChartCard(
                        title: 'Completion Rate',
                        subtitle: 'Daily completion trend for selected range',
                        child: CompletionRateChart(points: data.points),
                      ),
                      const SizedBox(height: 16),
                      AnalyticsChartCard(
                        title: 'Completed vs Scheduled',
                        subtitle: 'Per-day completed habits compared to target',
                        child: CompletedVsScheduledChart(
                          points: data.points,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AiInsightsCard(
                        analyticsData: data,
                        habits: habitsAsync.value ?? [],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const BottomNavBar(currentItem: BottomNavItem.analytics),
        ],
      ),
    );
  }
}
