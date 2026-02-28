import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';

Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Confirm',
  Color? confirmColor,
}) async {
  final colors = AppColors.of(context);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: colors.surface,
      title: Text(title, style: TextStyle(color: colors.textPrimary)),
      content: Text(message, style: TextStyle(color: colors.textSecondary)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(
            confirmText,
            style: TextStyle(color: confirmColor ?? colors.error),
          ),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}
