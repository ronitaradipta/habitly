import 'package:flutter/material.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';

class HomeHabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HomeHabitTile({
    super.key,
    required this.habit,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Format completion time text
    final completionText = habit.isCompleted
        ? 'Completed at ${habit.completionTime ?? "N/A"}'
        : 'Usually Completed at ${habit.completionTime ?? "N/A"}';

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showActionMenu(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.textSecondary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Completion indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: habit.isCompleted ? colors.primary : colors.surface,
                border: Border.all(
                  color: habit.isCompleted
                      ? colors.primary
                      : colors.textSecondary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: habit.isCompleted
                  ? Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            // Habit details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: AppTextStyles.body(context)
                        .copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: colors.textPrimary,
                          decoration: habit.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    completionText,
                    style: AppTextStyles.caption(
                      context,
                    ).copyWith(color: colors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            // Action buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onEdit != null)
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: colors.textSecondary,
                    ),
                    onPressed: onEdit,
                    tooltip: 'Edit',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: colors.error,
                    ),
                    onPressed: onDelete,
                    tooltip: 'Delete',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show action menu on long press
  void _showActionMenu(BuildContext context) {
    final colors = AppColors.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: colors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline, color: colors.primary),
              title: Text(
                habit.isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
                style: TextStyle(color: colors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                onTap?.call();
              },
            ),
            if (onEdit != null)
              ListTile(
                leading: Icon(Icons.edit_outlined, color: colors.textPrimary),
                title: Text(
                  'Edit Habit',
                  style: TextStyle(color: colors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onEdit?.call();
                },
              ),
            if (onDelete != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: colors.error),
                title: Text(
                  'Delete Habit',
                  style: TextStyle(color: colors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
