import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/widgets/shared/dialogs/confirm_dialog.dart';

Future<void> handleLogout(
  BuildContext context,
  WidgetRef ref, {
  bool popBeforeLogout = false,
}) async {
  final confirmed = await showConfirmDialog(
    context: context,
    title: 'Logout',
    message: 'Are you sure you want to logout?',
    confirmText: 'Logout',
  );

  if (confirmed && context.mounted) {
    if (popBeforeLogout) {
      Navigator.pop(context);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).logout();
    });
  }
}
