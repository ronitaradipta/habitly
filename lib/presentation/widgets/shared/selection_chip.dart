import 'package:flutter/material.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:sizer/sizer.dart';

class SelectionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color primaryColor;
  final Color backgroundColor;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const SelectionChip({
    super.key,
    required this.icon,
    required this.label,
    required this.primaryColor,
    required this.backgroundColor,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: primaryColor, size: 18.sp),
          SizedBox(width: 8.sp),
          Text(
            label,
            style: AppTextStyles.body(
              context,
            ).copyWith(color: primaryColor, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 12.sp),
          GestureDetector(
            onTap: onEdit,
            child: Icon(Icons.edit_outlined, color: primaryColor, size: 18.sp),
          ),
          SizedBox(width: 8.sp),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, color: primaryColor, size: 18.sp),
          ),
        ],
      ),
    );
  }
}
