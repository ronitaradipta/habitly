import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/presentation/utils/snackbar_utils.dart';

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
      AppSnackBar.showError(
        context,
        error.toString().replaceAll('Exception: ', ''),
      );
    },
    loading: () {},
  );
}
