import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/daily_analytics_point.dart';
import 'package:intl/intl.dart';

class CompletedVsScheduledChart extends StatelessWidget {
  final List<DailyAnalyticsPoint> points;

  const CompletedVsScheduledChart({super.key, required this.points});

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
