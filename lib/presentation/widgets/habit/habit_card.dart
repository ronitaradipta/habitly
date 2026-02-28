import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/presentation/theme/icon_mapper.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/widgets/shared/selectable_card.dart';

class HabitCard extends StatelessWidget {
  final String id;
  final String name;
  final String iconName;
  final bool isSelected;
  final VoidCallback onTap;

  const HabitCard({
    super.key,
    required this.id,
    required this.name,
    required this.iconName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SelectableCard(
      isSelected: isSelected,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconMapper.toIconData(iconName),
            size: 48,
            color: isSelected ? colors.primary : colors.textPrimary,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: AppTextStyles.body(context).copyWith(
              fontWeight: FontWeight.w500,
              color: isSelected ? colors.primary : colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
