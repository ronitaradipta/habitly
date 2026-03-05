import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/presentation/widgets/shared/dialogs/confirm_dialog.dart';
import 'package:habitly/presentation/widgets/shared/navigation/bottom_nav_bar.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:sizer/sizer.dart';

class ProfileMenuPage extends ConsumerWidget {
  const ProfileMenuPage({super.key});

  String _getUserInitials(User user) {
    final nameParts = user.fullName.trim().split(' ');
    if (nameParts.isEmpty) return 'U';

    final firstInitial =
        nameParts[0].isNotEmpty ? nameParts[0][0].toUpperCase() : '';

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authProvider.notifier).logout();
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final userAsync = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next is AsyncData<User?> && next.value == null && context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.launch, (route) => false);
      }
    });

    return ThemeScaffold(
      showThemeButton: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Profile', style: AppTextStyles.headingMedium(context)),
                const ThemeSwitchButton(),
              ],
            ),
          ),

          // User profile card
          userAsync.when(
            loading: () => _ProfileCard(
              colors: colors,
              avatar: CircleAvatar(
                radius: 28.sp,
                backgroundColor: colors.surface,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                ),
              ),
              name: 'Loading...',
              email: '',
            ),
            error: (e, st) => _ProfileCard(
              colors: colors,
              avatar: CircleAvatar(
                radius: 28.sp,
                backgroundColor: colors.surface,
                child: Icon(Icons.error_outline, color: colors.error, size: 28.sp),
              ),
              name: 'Error',
              email: '',
            ),
            data: (user) {
              final name = user != null && user.fullName.isNotEmpty
                  ? user.fullName
                  : 'User';
              final email = user?.email ?? '';
              return _ProfileCard(
                colors: colors,
                avatar: CircleAvatar(
                  radius: 28.sp,
                  backgroundColor: colors.surface,
                  child: user != null
                      ? Text(
                          _getUserInitials(user),
                          style: AppTextStyles.headingSmall(
                            context,
                          ).copyWith(color: colors.primary, fontSize: 18.sp),
                        )
                      : Icon(Icons.person, color: colors.primary, size: 28.sp),
                ),
                name: name,
                email: email,
              );
            },
          ),

          const SizedBox(height: 16),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _MenuItem(
                  icon: Icons.bar_chart_outlined,
                  label: 'Analytics',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.analytics),
                ),
                _MenuItem(
                  icon: Icons.person_outlined,
                  label: 'Profile',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const Divider(height: 32),
                _MenuItem(
                  icon: Icons.logout,
                  label: 'Logout',
                  color: colors.error,
                  onTap: () => _handleLogout(context, ref),
                ),
              ],
            ),
          ),

          BottomNavBar(currentItem: BottomNavItem.profile),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final AppColors colors;
  final Widget avatar;
  final String name;
  final String email;

  const _ProfileCard({
    required this.colors,
    required this.avatar,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withValues(alpha: 0.9),
            colors.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          avatar,
          const SizedBox(width: 16),
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
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: AppTextStyles.body(
                      context,
                    ).copyWith(color: colors.surface.withValues(alpha: 0.9)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final itemColor = color ?? colors.textPrimary;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: itemColor),
      title: Text(
        label,
        style: AppTextStyles.body(context).copyWith(color: itemColor),
      ),
      trailing: Icon(Icons.chevron_right, color: colors.textSecondary),
      onTap: onTap,
    );
  }
}
