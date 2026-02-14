import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';

class InputLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const InputLabel({super.key, required this.label, this.isRequired = true});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Text.rich(
      TextSpan(
        text: label,
        style: AppTextStyles.inputLabel(context, FontEngine.google),
        children: [
          if (isRequired)
            TextSpan(
              text: " *",
              style: TextStyle(color: colors.error),
            ),
        ],
      ),
    );
  }
}
