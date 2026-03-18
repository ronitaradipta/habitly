import 'package:flutter/material.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/core/theme/app_colors.dart';

enum BottomNavItem { home, analytics, add, aiChat, profile }

class BottomNavBar extends StatelessWidget {
  final BottomNavItem currentItem;

  const BottomNavBar({super.key, required this.currentItem});

  void _handleTap(BuildContext context, BottomNavItem item) {
    if (item == currentItem) return;

    switch (item) {
      case BottomNavItem.home:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case BottomNavItem.analytics:
        Navigator.pushReplacementNamed(context, AppRoutes.analytics);
        break;
      case BottomNavItem.add:
        Navigator.pushNamed(context, AppRoutes.addHabit);
        break;
      case BottomNavItem.aiChat:
        Navigator.pushReplacementNamed(context, AppRoutes.aiChat);
        break;
      case BottomNavItem.profile:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
    }
  }

  Widget _buildIcon(
    BuildContext context,
    BottomNavItem item,
    IconData activeIcon,
    IconData inactiveIcon,
    AppColors colors,
  ) {
    final isActive = currentItem == item;
    return GestureDetector(
      onTap: () => _handleTap(context, item),
      child: Icon(
        isActive ? activeIcon : inactiveIcon,
        size: 26,
        color: isActive ? colors.textPrimary : colors.textSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(color: colors.background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIcon(
            context,
            BottomNavItem.home,
            Icons.home,
            Icons.home_outlined,
            colors,
          ),
          _buildIcon(
            context,
            BottomNavItem.analytics,
            Icons.bar_chart,
            Icons.bar_chart_outlined,
            colors,
          ),

          // Center Add button
          GestureDetector(
            onTap: () => _handleTap(context, BottomNavItem.add),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary,
              ),
              child: Icon(Icons.add, size: 28, color: colors.surface),
            ),
          ),

          _buildIcon(
            context,
            BottomNavItem.aiChat,
            Icons.chat_bubble,
            Icons.chat_bubble_outline,
            colors,
          ),
          _buildIcon(
            context,
            BottomNavItem.profile,
            Icons.person,
            Icons.person_outlined,
            colors,
          ),
        ],
      ),
    );
  }
}
