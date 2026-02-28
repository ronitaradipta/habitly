import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/domain/entities/category.dart';
import 'package:habitly/presentation/theme/category_colors.dart';
import 'package:habitly/presentation/theme/icon_mapper.dart';
import 'package:habitly/presentation/widgets/habit/category_drawer.dart';
import 'package:habitly/presentation/widgets/shared/form_row_selector.dart';

class CategorySelector extends StatelessWidget {
  final HabitCategory? selectedCategory;
  final Function(HabitCategory) onCategorySelected;
  final VoidCallback onCategoryRemoved;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onCategoryRemoved,
  });

  void _showCategoryDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryDrawer(
        selectedCategory: selectedCategory,
        onCategorySelected: onCategorySelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hasCategory = selectedCategory != null;

    final iconData = hasCategory
        ? IconMapper.toIconData(selectedCategory!.iconName)
        : Icons.category_outlined;
    final iconColor = hasCategory
        ? Color(selectedCategory!.primaryColorValue)
        : colors.textSecondary;
    final valueText = hasCategory
        ? selectedCategory!.displayName
        : 'Select category';

    return FormRowSelector(
      icon: iconData,
      iconColor: iconColor,
      label: 'Category',
      value: valueText,
      hasValue: hasCategory,
      onTap: () => _showCategoryDrawer(context),
    );
  }
}
