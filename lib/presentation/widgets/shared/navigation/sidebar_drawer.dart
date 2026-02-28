import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/widgets/shared/dialogs/confirm_dialog.dart';
import 'package:sizer/sizer.dart';

class SidebarDrawer extends ConsumerWidget {
  const SidebarDrawer({super.key});

  String _getUserInitials(User user) {
    final nameParts = user.fullName.trim().split(' ');
    if (nameParts.isEmpty) return 'U';

    final firstInitial = nameParts[0].isNotEmpty
        ? nameParts[0][0].toUpperCase()
        : '';

    if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
      final secondInitial = nameParts[1][0].toUpperCase();
      return '$firstInitial$secondInitial';
    }

    return firstInitial;
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
    );

    if (confirmed && context.mounted) {
      Navigator.pop(context); // Close drawer before logout
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authProvider.notifier).logout();
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final userAsync = ref.watch(authProvider);

    return Drawer(
      width: 75.w > 320 ? 320 : 75.w,
      backgroundColor: colors.surface,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.primary.withValues(alpha: 0.9),
                    colors.primary,
                  ],
                ),
              ),
              child: userAsync.when(
                data: (user) {
                  final name = user != null && user.fullName.isNotEmpty
                      ? user.fullName
                      : (user != null ? 'User' : 'Guest');
                  final email = user?.email ?? 'Not logged in';
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 24.sp,
                        backgroundColor: colors.surface,
                        child: user != null
                            ? Text(
                                _getUserInitials(user),
                                style: AppTextStyles.headingSmall(
                                  context,
                                ).copyWith(color: colors.primary),
                              )
                            : Icon(
                                Icons.person,
                                color: colors.primary,
                                size: 24.sp,
                              ),
                      ),
                      SizedBox(width: 12.sp),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: AppTextStyles.headingSmall(
                                context,
                              ).copyWith(color: colors.surface),
                            ),
                            SizedBox(height: 2.sp),
                            Text(
                              email,
                              style: AppTextStyles.body(context).copyWith(
                                color: colors.surface.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                loading: () => Row(
                  children: [
                    CircleAvatar(
                      radius: 24.sp,
                      backgroundColor: colors.surface,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.sp),
                    Text(
                      'Loading...',
                      style: AppTextStyles.headingSmall(
                        context,
                      ).copyWith(color: colors.surface),
                    ),
                  ],
                ),
                error: (_, _) => Row(
                  children: [
                    CircleAvatar(
                      radius: 24.sp,
                      backgroundColor: colors.surface,
                      child: Icon(
                        Icons.error_outline,
                        color: colors.error,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.sp),
                    Text(
                      'Error',
                      style: AppTextStyles.headingSmall(
                        context,
                      ).copyWith(color: colors.surface),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: colors.textPrimary,
                    ),
                    title: Text('Profile', style: AppTextStyles.body(context)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings_outlined,
                      color: colors.textPrimary,
                    ),
                    title: Text('Settings', style: AppTextStyles.body(context)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: colors.textPrimary,
                    ),
                    title: Text(
                      'Help & Support',
                      style: AppTextStyles.body(context),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: colors.error),
                    title: Text(
                      'Logout',
                      style: AppTextStyles.body(
                        context,
                      ).copyWith(color: colors.error),
                    ),
                    onTap: () => _handleLogout(context, ref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
