import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/analytics_summary.dart';

class AnalyticsSummaryGrid extends StatelessWidget {
  final AnalyticsSummary summary;

  const AnalyticsSummaryGrid({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final avgPercent = (summary.avgCompletionRate * 100).round();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: _SummaryCard(
                title: 'Average Completion',
                value: '$avgPercent%',
                subtitle: '${summary.totalCompleted}/${summary.totalScheduled}',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _SummaryCard(
                title: 'Current Streak',
                value: '${summary.currentStreak}',
                subtitle: 'perfect active days',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _SummaryCard(
                title: 'Perfect Days',
                value: '${summary.perfectDays}',
                subtitle: 'days with 100% completion',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _SummaryCard(
                title: 'Best Streak',
                value: '${summary.bestStreak}',
                subtitle: 'best run in range',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
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
          Text(
            title,
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.headingSmall(
              context,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTextStyles.captionSmall(context)),
        ],
      ),
    );
  }
}
