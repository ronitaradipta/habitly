import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';

enum BottomNavItem { home, add, profile }

class BottomNavBar extends StatelessWidget {
  final BottomNavItem currentItem;
  final ValueChanged<BottomNavItem>? onItemTapped;

  const BottomNavBar({super.key, required this.currentItem, this.onItemTapped});

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
            onTap: () => onItemTapped?.call(BottomNavItem.home),
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
            onTap: () => onItemTapped?.call(BottomNavItem.add),
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
            onTap: () => onItemTapped?.call(BottomNavItem.profile),
            child: Icon(
              currentItem == BottomNavItem.profile
                  ? Icons.person
                  : Icons.person_outline,
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
