import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/widgets/habit/reminder_chip.dart';
import 'package:habitly/presentation/widgets/shared/dialogs/app_time_picker.dart';
import 'package:sizer/sizer.dart';

class ReminderSelector extends StatelessWidget {
  final bool hasReminder;
  final TimeOfDay? reminderTime;
  final Function(bool) onReminderToggled;
  final Function(TimeOfDay) onTimeSelected;
  final VoidCallback onReminderRemoved;

  const ReminderSelector({
    super.key,
    required this.hasReminder,
    required this.reminderTime,
    required this.onReminderToggled,
    required this.onTimeSelected,
    required this.onReminderRemoved,
  });

  Future<void> _showTimePicker(BuildContext context) async {
    final picked = await showAppTimePicker(
      context,
      initialTime: reminderTime,
    );

    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasReminder && reminderTime != null)
          ReminderChip(
            time: reminderTime!,
            onEdit: () => _showTimePicker(context),
            onRemove: onReminderRemoved,
          )
        else
          GestureDetector(
            onTap: () => _showTimePicker(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
              decoration: BoxDecoration(
                border: Border.all(color: colors.textSecondary.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: colors.textSecondary,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.sp),
                  Text(
                    'Add reminder',
                    style: AppTextStyles.body(context).copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
