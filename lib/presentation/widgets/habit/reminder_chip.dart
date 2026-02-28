import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/utils/time_utils.dart';
import 'package:habitly/presentation/widgets/shared/selection_chip.dart';

class ReminderChip extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const ReminderChip({
    super.key,
    required this.time,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SelectionChip(
      icon: Icons.access_time,
      label: TimeUtils.formatForDisplay(time),
      primaryColor: colors.primary,
      backgroundColor: colors.primary.withValues(alpha: 0.1),
      onEdit: onEdit,
      onRemove: onRemove,
    );
  }
}
