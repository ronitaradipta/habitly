import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/providers/analytics_provider.dart';
import 'package:intl/intl.dart';

class CompletionRateChart extends StatelessWidget {
  final List<DailyAnalyticsPoint> points;

  const CompletionRateChart({super.key, required this.points});

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
