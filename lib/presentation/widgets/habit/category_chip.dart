import 'package:flutter/material.dart';
import 'package:habitly/domain/entities/category.dart';
import 'package:habitly/presentation/theme/category_colors.dart';
import 'package:habitly/presentation/theme/icon_mapper.dart';
import 'package:habitly/presentation/widgets/shared/selection_chip.dart';

class CategoryChip extends StatelessWidget {
  final HabitCategory category;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const CategoryChip({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionChip(
      icon: IconMapper.toIconData(category.iconName),
      label: category.displayName,
      primaryColor: Color(category.primaryColorValue),
      backgroundColor: Color(category.lightColorValue),
      onEdit: onEdit,
      onRemove: onRemove,
    );
  }
}
