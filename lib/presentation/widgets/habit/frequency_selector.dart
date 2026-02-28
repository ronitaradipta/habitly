import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:sizer/sizer.dart';

class FrequencySelector extends StatefulWidget {
  final HabitFrequency? selectedFrequency;
  final int? customDays;
  final Function(HabitFrequency) onFrequencyChanged;
  final Function(int) onCustomDaysChanged;

  const FrequencySelector({
    super.key,
    this.selectedFrequency,
    this.customDays,
    required this.onFrequencyChanged,
    required this.onCustomDaysChanged,
  });

  @override
  State<FrequencySelector> createState() => _FrequencySelectorState();
}

class _FrequencySelectorState extends State<FrequencySelector> {
  late TextEditingController _customDaysController;
  late int _customDaysValue;

  @override
  void initState() {
    super.initState();
    _customDaysValue = widget.customDays ?? 2;
    _customDaysController = TextEditingController(
      text: _customDaysValue.toString(),
    );
  }

  @override
  void dispose() {
    _customDaysController.dispose();
    super.dispose();
  }

  void _updateCustomDays(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null && parsed >= 1 && parsed <= 365) {
      setState(() {
        _customDaysValue = parsed;
      });
      widget.onCustomDaysChanged(parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
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

        // Frequency options card
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (int i = 0; i < frequencies.length; i++) ...[
                _FrequencyListItem(
                  frequency: frequencies[i],
                  isSelected: widget.selectedFrequency == frequencies[i],
                  onTap: () => widget.onFrequencyChanged(frequencies[i]),
                ),
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

        // Custom Days Input
        if (widget.selectedFrequency == HabitFrequency.customDays) ...[
          SizedBox(height: 16.sp),
          _CustomDaysInput(
            controller: _customDaysController,
            value: _customDaysValue,
            onChanged: _updateCustomDays,
            onIncrement: () {
              if (_customDaysValue < 365) {
                final newValue = _customDaysValue + 1;
                _customDaysController.text = newValue.toString();
                _updateCustomDays(newValue.toString());
              }
            },
            onDecrement: () {
              if (_customDaysValue > 1) {
                final newValue = _customDaysValue - 1;
                _customDaysController.text = newValue.toString();
                _updateCustomDays(newValue.toString());
              }
            },
          ),
          SizedBox(height: 8.sp),
          Text(
            'Repeat every $_customDaysValue day${_customDaysValue > 1 ? "s" : ""}',
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: colors.textSecondary, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class _FrequencyListItem extends StatelessWidget {
  final HabitFrequency frequency;
  final bool isSelected;
  final VoidCallback onTap;

  const _FrequencyListItem({
    required this.frequency,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
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

class _CustomDaysInput extends StatelessWidget {
  final TextEditingController controller;
  final int value;
  final Function(String) onChanged;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CustomDaysInput({
    required this.controller,
    required this.value,
    required this.onChanged,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

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
          // Decrement Button
          _StepperButton(
            icon: Icons.remove,
            onTap: onDecrement,
            isEnabled: value > 1,
          ),

          // Number Input
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
              onChanged: onChanged,
            ),
          ),

          // Increment Button
          _StepperButton(
            icon: Icons.add,
            onTap: onIncrement,
            isEnabled: value < 365,
          ),
        ],
      ),
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
