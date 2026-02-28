import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/category.dart';
import 'package:habitly/presentation/theme/category_colors.dart';
import 'package:habitly/presentation/theme/icon_mapper.dart';
import 'package:sizer/sizer.dart';

class CategoryTile extends StatelessWidget {
  final HabitCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
        decoration: BoxDecoration(
          color: isSelected ? Color(category.lightColorValue) : colors.surface,
          border: Border.all(
            color: isSelected
                ? Color(category.primaryColorValue)
                : colors.textSecondary.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: Color(category.lightColorValue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                IconMapper.toIconData(category.iconName),
                color: Color(category.primaryColorValue),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.sp),
            Expanded(
              child: Text(
                category.displayName,
                style: AppTextStyles.body(context).copyWith(
                  color: isSelected
                      ? Color(category.primaryColorValue)
                      : colors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Color(category.primaryColorValue),
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}
