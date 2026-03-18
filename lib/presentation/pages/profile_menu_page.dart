import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/utils/auth_listener.dart';
import 'package:habitly/presentation/utils/user_display_utils.dart';
import 'package:habitly/presentation/widgets/profile/profile_card.dart';
import 'package:habitly/presentation/widgets/profile/profile_menu_item.dart';
import 'package:habitly/presentation/utils/logout_handler.dart';
import 'package:habitly/presentation/utils/snackbar_utils.dart';
import 'package:habitly/presentation/widgets/shared/navigation/custom_app_bar.dart';
import 'package:habitly/presentation/widgets/shared/navigation/bottom_nav_bar.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:sizer/sizer.dart';

class ProfileMenuPage extends ConsumerWidget {
  const ProfileMenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final userAsync = ref.watch(authProvider);

    listenForAuthRedirect(ref, context);

    void showComingSoon() {
      AppSnackBar.show(context, 'Coming soon');
    }

    return ThemeScaffold(
      showThemeButton: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(title: 'Profile'),

          // User profile card
          userAsync.when(
            loading: () => ProfileCard(
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
            error: (e, st) => ProfileCard(
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
              return ProfileCard(
                avatar: CircleAvatar(
                  radius: 28.sp,
                  backgroundColor: colors.surface,
                  child: user != null
                      ? Text(
                          getUserInitials(user),
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
                ProfileMenuItem(
                  icon: Icons.person_outlined,
                  label: 'Profile',
                  onTap: showComingSoon,
                ),
                ProfileMenuItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: showComingSoon,
                ),
                const Divider(height: 32),
                ProfileMenuItem(
                  icon: Icons.logout,
                  label: 'Logout',
                  color: colors.error,
                  onTap: () => handleLogout(context, ref),
                ),
              ],
            ),
          ),

          const BottomNavBar(currentItem: BottomNavItem.profile),
        ],
      ),
    );
  }
}
