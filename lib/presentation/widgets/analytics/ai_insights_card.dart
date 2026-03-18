import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/ai_insight.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/presentation/providers/ai_insights_provider.dart';
import 'package:habitly/presentation/providers/analytics_provider.dart';

class AiInsightsCard extends ConsumerWidget {
  final AnalyticsData analyticsData;
  final List<Habit> habits;

  const AiInsightsCard({
    super.key,
    required this.analyticsData,
    required this.habits,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(aiInsightsProvider);
    final colors = AppColors.of(context);

    void generate() => ref
        .read(aiInsightsProvider.notifier)
        .generateInsights(habits, analyticsData.range, analyticsData.summary);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colors.textSecondary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 20, color: colors.dateOrange),
              const SizedBox(width: 8),
              Text(
                'AI Insights',
                style: AppTextStyles.headingSmall(
                  context,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          insightsAsync.when(
            loading: () => const _InsightsLoading(),
            error: (e, _) =>
                _InsightsError(message: e.toString(), onRetry: generate),
            data: (insights) {
              if (insights.isEmpty) {
                return _InsightsEmpty(onGenerate: generate);
              }
              return _InsightsLoaded(insights: insights, onRefresh: generate);
            },
          ),
        ],
      ),
    );
  }
}

class _InsightsEmpty extends StatelessWidget {
  final VoidCallback onGenerate;
  const _InsightsEmpty({required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get personal insights about your habit patterns.',
          style: AppTextStyles.caption(
            context,
          ).copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onGenerate,
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('Get AI Insights'),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primary,
              side: BorderSide(color: colors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _InsightsLoading extends StatelessWidget {
  const _InsightsLoading();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 8),
          CircularProgressIndicator(color: colors.primary),
          const SizedBox(height: 12),
          Text(
            'Analyzing your habits...',
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _InsightsLoaded extends StatelessWidget {
  final List<AiInsight> insights;
  final VoidCallback onRefresh;

  const _InsightsLoaded({required this.insights, required this.onRefresh});

  Icon _iconFor(InsightType type, AppColors colors) {
    return switch (type) {
      InsightType.positive => Icon(
        Icons.star_rounded,
        size: 20,
        color: colors.primary,
      ),
      InsightType.warning => Icon(
        Icons.warning_amber_rounded,
        size: 20,
        color: colors.dateOrange,
      ),
      InsightType.tip => Icon(
        Icons.lightbulb_outline_rounded,
        size: 20,
        color: colors.dateBlue,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...insights.map(
          (insight) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _iconFor(insight.type, colors),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    insight.text,
                    style: AppTextStyles.caption(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onRefresh,
            icon: Icon(Icons.refresh, size: 16, color: colors.primary),
            label: Text(
              'Refresh Insights',
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: colors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _InsightsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InsightsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Failed to load insights. Please try again.',
          style: AppTextStyles.caption(context).copyWith(color: colors.error),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: onRetry,
          icon: Icon(Icons.refresh, size: 16, color: colors.primary),
          label: Text(
            'Try again',
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: colors.primary),
          ),
        ),
      ],
    );
  }
}
