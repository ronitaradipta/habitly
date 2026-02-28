import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/domain/entities/user.dart';

void handleAuthResult({
  required BuildContext context,
  required AsyncValue<User?> authState,
  required void Function(User) onSuccess,
}) {
  authState.when(
    data: (user) {
      if (user != null) {
        onSuccess(user);
      }
    },
    error: (error, _) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.of(context).error,
        ),
      );
    },
    loading: () {},
  );
}
