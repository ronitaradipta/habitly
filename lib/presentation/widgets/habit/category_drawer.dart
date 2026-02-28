import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/category.dart';
import 'package:habitly/presentation/widgets/habit/category_tile.dart';
import 'package:habitly/presentation/widgets/shared/modal_handle_bar.dart';
import 'package:sizer/sizer.dart';

class CategoryDrawer extends StatelessWidget {
  final HabitCategory? selectedCategory;
  final Function(HabitCategory) onCategorySelected;

  const CategoryDrawer({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ModalHandleBar(),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 8.sp),
            child: Row(
              children: [
                Text(
                  'Select Category',
                  style: AppTextStyles.headingSmall(context),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.grey),

          // Category list
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 70.h),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 8.sp),
              itemCount: HabitCategory.values.length,
              itemBuilder: (context, index) {
                final category = HabitCategory.values[index];
                final isSelected = selectedCategory == category;

                return CategoryTile(
                  category: category,
                  isSelected: isSelected,
                  onTap: () {
                    onCategorySelected(category);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
