import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/domain/entities/analytics_range.dart';

class AnalyticsRangeSelector extends StatelessWidget {
  final AnalyticsRange selectedRange;
  final ValueChanged<AnalyticsRange> onChanged;

  const AnalyticsRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SegmentedButton<AnalyticsRange>(
      style: SegmentedButton.styleFrom(
        backgroundColor: colors.surface,
        selectedForegroundColor: colors.background,
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
