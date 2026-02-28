import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_text_field.dart';

class AppPhoneField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const AppPhoneField({
    super.key,
    this.onChanged,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country code selector (Currently static +62)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              // Indonesia flag placeholder
              Container(
                width: 24,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  children: [
                    Expanded(child: Container(color: Colors.red)),
                    Expanded(child: Container(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "+62",
                style: AppTextStyles.body(context),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Phone number field
        Expanded(
          child: AppTextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
