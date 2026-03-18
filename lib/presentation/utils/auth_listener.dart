import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';

void listenForAuthRedirect(WidgetRef ref, BuildContext context) {
  ref.listen(authProvider, (previous, next) {
    if (next is AsyncData<User?> && next.value == null && context.mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.launch, (route) => false);
    }
  });
}
