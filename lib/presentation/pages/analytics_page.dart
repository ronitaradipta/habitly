import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/presentation/providers/analytics_provider.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/presentation/widgets/shared/navigation/bottom_nav_bar.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:intl/intl.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsDataProvider);

    ref.listen(authProvider, (previous, next) {
      if (next is AsyncData<User?> && next.value == null && context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.launch, (route) => false);
      }
    });

    return ThemeScaffold(
      showThemeButton: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Analytics',
                  style: AppTextStyles.headingMedium(context),
                ),
                const ThemeSwitchButton(),
              ],
            ),
          ),
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
                    _RangeSelector(
                      selectedRange: data.range,
                      onChanged: (range) {
                        ref
                            .read(analyticsRangeProvider.notifier)
                            .setRange(range);
                      },
                    ),
                    const SizedBox(height: 16),
                    if (!data.hasScheduledData) ...[
                      const _EmptyAnalyticsState(),
                    ] else ...[
                      _SummaryGrid(summary: data.summary),
                      const SizedBox(height: 20),
                      _ChartCard(
                        title: 'Completion Rate',
                        subtitle: 'Daily completion trend for selected range',
                        child: _CompletionRateLineChart(points: data.points),
                      ),
                      const SizedBox(height: 16),
                      _ChartCard(
                        title: 'Completed vs Scheduled',
                        subtitle: 'Per-day completed habits compared to target',
                        child: _CompletedVsScheduledBarChart(
                          points: data.points,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const BottomNavBar(currentItem: BottomNavItem.profile),
        ],
      ),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  final AnalyticsRange selectedRange;
  final ValueChanged<AnalyticsRange> onChanged;

  const _RangeSelector({required this.selectedRange, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SegmentedButton<AnalyticsRange>(
      style: SegmentedButton.styleFrom(
        selectedForegroundColor: colors.surface,
        selectedBackgroundColor: colors.primary,
      ),
      segments: AnalyticsRange.values
          .map(
            (range) => ButtonSegment<AnalyticsRange>(
              value: range,
              label: Text(range.label),
            ),
          )
          .toList(),
      selected: {selectedRange},
      onSelectionChanged: (selection) {
        if (selection.isNotEmpty) {
          onChanged(selection.first);
        }
      },
      showSelectedIcon: false,
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  final AnalyticsSummary summary;

  const _SummaryGrid({required this.summary});

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

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
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
            style: AppTextStyles.headingSmall(
              context,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 220, child: child),
        ],
      ),
    );
  }
}

class _CompletionRateLineChart extends StatelessWidget {
  final List<DailyAnalyticsPoint> points;

  const _CompletionRateLineChart({required this.points});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final spots = List<FlSpot>.generate(points.length, (index) {
      final rate = points[index].completionRate;
      if (rate == null) return FlSpot.nullSpot;
      return FlSpot(index.toDouble(), rate * 100);
    });

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (points.length - 1).toDouble(),
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: colors.border.withValues(alpha: 0.4),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              interval: 25,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: AppTextStyles.small(
                    context,
                  ).copyWith(color: colors.textSecondary),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.length) {
                  return const SizedBox.shrink();
                }

                final isFirst = index == 0;
                final isMiddle = index == points.length ~/ 2;
                final isLast = index == points.length - 1;

                if (!isFirst && !isMiddle && !isLast) {
                  return const SizedBox.shrink();
                }

                return Text(
                  DateFormat('M/d').format(points[index].date),
                  style: AppTextStyles.small(
                    context,
                  ).copyWith(color: colors.textSecondary),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => colors.textPrimary,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                final point = points[index];
                final completionPercent = ((point.completionRate ?? 0.0) * 100)
                    .round();
                return LineTooltipItem(
                  '${DateFormat('d MMM').format(point.date)}\n$completionPercent%',
                  AppTextStyles.captionSmall(context).copyWith(
                    color: colors.surface,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            isStrokeCapRound: true,
            color: colors.primary,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: colors.primary.withValues(alpha: 0.16),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedVsScheduledBarChart extends StatelessWidget {
  final List<DailyAnalyticsPoint> points;

  const _CompletedVsScheduledBarChart({required this.points});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final maxScheduled = points.fold<int>(
      0,
      (max, point) => point.scheduledCount > max ? point.scheduledCount : max,
    );

    final groups = List<BarChartGroupData>.generate(points.length, (index) {
      final point = points[index];
      return BarChartGroupData(
        x: index,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: point.scheduledCount.toDouble(),
            width: 5,
            color: colors.textSecondary.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(2),
          ),
          BarChartRodData(
            toY: point.completedCount.toDouble(),
            width: 5,
            color: colors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _LegendItem(color: colors.primary, label: 'Completed'),
            _LegendItem(
              color: colors.textSecondary.withValues(alpha: 0.35),
              label: 'Scheduled',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: maxScheduled == 0 ? 1 : maxScheduled.toDouble() + 1,
              barGroups: groups,
              alignment: BarChartAlignment.spaceAround,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: colors.border.withValues(alpha: 0.4),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => colors.textPrimary,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final point = points[group.x.toInt()];
                    return BarTooltipItem(
                      '${DateFormat('d MMM').format(point.date)}\n'
                      '${point.completedCount}/${point.scheduledCount}',
                      AppTextStyles.captionSmall(context).copyWith(
                        color: colors.surface,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: (maxScheduled / 4).clamp(1, 999).toDouble(),
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: AppTextStyles.small(
                          context,
                        ).copyWith(color: colors.textSecondary),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 26,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= points.length) {
                        return const SizedBox.shrink();
                      }

                      final isFirst = index == 0;
                      final isMiddle = index == points.length ~/ 2;
                      final isLast = index == points.length - 1;

                      if (!isFirst && !isMiddle && !isLast) {
                        return const SizedBox.shrink();
                      }

                      return Text(
                        DateFormat('M/d').format(points[index].date),
                        style: AppTextStyles.small(
                          context,
                        ).copyWith(color: colors.textSecondary),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.captionSmall(
            context,
          ).copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _EmptyAnalyticsState extends StatelessWidget {
  const _EmptyAnalyticsState();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No analytics yet', style: AppTextStyles.headingSmall(context)),
          const SizedBox(height: 8),
          Text(
            'Add habits and start checking them off to see your trend here.',
            style: AppTextStyles.caption(context),
          ),
        ],
      ),
    );
  }
}
