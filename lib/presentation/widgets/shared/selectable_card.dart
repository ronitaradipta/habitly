import 'package:flutter/material.dart';
import 'package:habitly/core/constants/app_decorations.dart';
import 'package:habitly/core/theme/app_colors.dart';

class SelectableCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  const SelectableCard({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppDecorations.cardBorderRadius,
          border: isSelected
              ? Border.all(color: colors.primary, width: 2)
              : null,
          boxShadow: const [AppDecorations.cardShadow],
        ),
        child: child,
      ),
    );
  }
}
