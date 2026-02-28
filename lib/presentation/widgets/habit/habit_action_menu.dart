import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/presentation/widgets/shared/modal_handle_bar.dart';

void showHabitActionMenu({
  required BuildContext context,
  required bool isCompleted,
  required VoidCallback onToggleCompletion,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
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
          const ModalHandleBar(),
          ListTile(
            leading: Icon(
              isCompleted ? Icons.check_circle_outline : Icons.check_circle,
              color: colors.primary,
            ),
            title: Text(
              isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
              style: TextStyle(color: colors.textPrimary),
            ),
            onTap: () {
              Navigator.pop(context);
              onToggleCompletion();
            },
          ),
          ListTile(
            leading: Icon(Icons.edit_outlined, color: colors.textPrimary),
            title: Text(
              'Edit Habit',
              style: TextStyle(color: colors.textPrimary),
            ),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: colors.error),
            title: Text('Delete Habit', style: TextStyle(color: colors.error)),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
