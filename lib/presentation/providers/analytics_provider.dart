import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/utils/analytics_calculator.dart';
import 'package:habitly/domain/entities/analytics_data.dart';
import 'package:habitly/domain/entities/analytics_range.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';

class AnalyticsRangeNotifier extends Notifier<AnalyticsRange> {
  @override
  AnalyticsRange build() => AnalyticsRange.last30;

  void setRange(AnalyticsRange range) {
    state = range;
  }
}

final analyticsRangeProvider =
    NotifierProvider<AnalyticsRangeNotifier, AnalyticsRange>(
      AnalyticsRangeNotifier.new,
    );

final analyticsDataProvider = Provider<AsyncValue<AnalyticsData>>((ref) {
  final habitsAsync = ref.watch(habitProvider);
  final range = ref.watch(analyticsRangeProvider);

  return habitsAsync.whenData(
    (habits) => buildAnalyticsData(habits: habits, range: range),
  );
});
