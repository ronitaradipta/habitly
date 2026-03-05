import 'package:flutter/material.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/core/theme/app_colors.dart';

enum BottomNavItem { home, add, profile }

class BottomNavBar extends StatelessWidget {
  final BottomNavItem currentItem;

  const BottomNavBar({super.key, required this.currentItem});

  void _handleTap(BuildContext context, BottomNavItem item) {
    if (item == currentItem) return;

    switch (item) {
      case BottomNavItem.home:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case BottomNavItem.add:
        Navigator.pushNamed(context, AppRoutes.addHabit);
        break;
      case BottomNavItem.profile:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
      decoration: BoxDecoration(color: colors.background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Home icon
          GestureDetector(
            onTap: () => _handleTap(context, BottomNavItem.home),
            child: Icon(
              currentItem == BottomNavItem.home
                  ? Icons.home
                  : Icons.home_outlined,
              size: 28,
              color: currentItem == BottomNavItem.home
                  ? colors.textPrimary
                  : colors.textSecondary,
            ),
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

          // Profile icon
          GestureDetector(
            onTap: () => _handleTap(context, BottomNavItem.profile),
            child: Icon(
              currentItem == BottomNavItem.profile
                  ? Icons.person
                  : Icons.person_outlined,
              size: 28,
              color: currentItem == BottomNavItem.profile
                  ? colors.textPrimary
                  : colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
