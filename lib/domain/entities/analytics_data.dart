import 'package:habitly/domain/entities/analytics_range.dart';
import 'package:habitly/domain/entities/analytics_summary.dart';
import 'package:habitly/domain/entities/daily_analytics_point.dart';

class AnalyticsData {
  final AnalyticsRange range;
  final List<DailyAnalyticsPoint> points;
  final AnalyticsSummary summary;

  const AnalyticsData({
    required this.range,
    required this.points,
    required this.summary,
  });

  bool get hasScheduledData => summary.totalScheduled > 0;
}
