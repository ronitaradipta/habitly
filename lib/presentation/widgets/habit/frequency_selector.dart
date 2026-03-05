import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:habitly/presentation/providers/habit_form_provider.dart';
import 'package:sizer/sizer.dart';

final _customDaysControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController(
    text: (ref.read(habitFormProvider).customDays ?? 2).toString(),
  );
  ref.onDispose(controller.dispose);
  ref.listen(habitFormProvider.select((s) => s.customDays), (_, next) {
    final newText = (next ?? 2).toString();
    if (controller.text != newText) controller.text = newText;
  });
  return controller;
});

class FrequencySelector extends ConsumerWidget {
  const FrequencySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final selectedFrequency =
        ref.watch(habitFormProvider.select((s) => s.selectedFrequency));
    final frequencies = HabitFrequency.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FREQUENCY',
          style: AppTextStyles.caption(context).copyWith(
            color: colors.textSecondary,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        SizedBox(height: 8.sp),

        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (int i = 0; i < frequencies.length; i++) ...[
                _FrequencyListItem(frequency: frequencies[i]),
                if (i < frequencies.length - 1)
                  Divider(
                    height: 1,
                    indent: 16.sp,
                    endIndent: 16.sp,
                    color: colors.textSecondary.withValues(alpha: 0.15),
                  ),
              ],
            ],
          ),
        ),

        if (selectedFrequency == HabitFrequency.customDays) ...[
          SizedBox(height: 16.sp),
          const _CustomDaysInput(),
          SizedBox(height: 8.sp),
          _CustomDaysLabel(),
        ],
      ],
    );
  }
}

class _FrequencyListItem extends ConsumerWidget {
  final HabitFrequency frequency;

  const _FrequencyListItem({required this.frequency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final isSelected = ref.watch(
      habitFormProvider.select((s) => s.selectedFrequency == frequency),
    );

    return GestureDetector(
      onTap: () =>
          ref.read(habitFormProvider.notifier).selectFrequency(frequency),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 14.sp),
        child: Row(
          children: [
            Expanded(
              child: Text(
                frequency.displayName,
                style: AppTextStyles.body(context).copyWith(
                  color: isSelected ? colors.primary : colors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check, color: colors.primary, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

class _CustomDaysInput extends ConsumerWidget {
  const _CustomDaysInput();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final customDays =
        ref.watch(habitFormProvider.select((s) => s.customDays ?? 2));
    final controller = ref.watch(_customDaysControllerProvider);

    void updateCustomDays(String value) {
      final parsed = int.tryParse(value);
      if (parsed != null && parsed >= 1 && parsed <= 365) {
        ref.read(habitFormProvider.notifier).setCustomDays(parsed);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.textSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StepperButton(
            icon: Icons.remove,
            isEnabled: customDays > 1,
            onTap: () {
              ref
                  .read(habitFormProvider.notifier)
                  .setCustomDays(customDays - 1);
            },
          ),

          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading(context).copyWith(
                fontSize: 20.sp,
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '2',
                hintStyle: AppTextStyles.heading(context).copyWith(
                  fontSize: 20.sp,
                  color: colors.textSecondary.withValues(alpha: 0.5),
                ),
              ),
              onChanged: updateCustomDays,
            ),
          ),

          _StepperButton(
            icon: Icons.add,
            isEnabled: customDays < 365,
            onTap: () {
              ref
                  .read(habitFormProvider.notifier)
                  .setCustomDays(customDays + 1);
            },
          ),
        ],
      ),
    );
  }
}

class _CustomDaysLabel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final customDays =
        ref.watch(habitFormProvider.select((s) => s.customDays ?? 2));

    return Text(
      'Repeat every $customDays day${customDays > 1 ? "s" : ""}',
      style: AppTextStyles.caption(
        context,
      ).copyWith(color: colors.textSecondary, fontSize: 12.sp),
      textAlign: TextAlign.center,
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isEnabled;

  const _StepperButton({
    required this.icon,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 48,
        height: 48,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isEnabled
              ? colors.primary.withValues(alpha: 0.1)
              : colors.textSecondary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isEnabled
              ? colors.primary
              : colors.textSecondary.withValues(alpha: 0.3),
          size: 20,
        ),
      ),
    );
  }
}
