import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';

class WeekDaySelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onDateSelected;

  const WeekDaySelector({
    super.key,
    required this.selectedDate,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final now = DateTime.now();

    // Get the start of the week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    // Generate list of days for the week
    final weekDays = List.generate(7, (index) {
      return startOfWeek.add(Duration(days: index));
    });

    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        final day = weekDays[index];
        final isToday =
            day.day == now.day &&
            day.month == now.month &&
            day.year == now.year;
        final isSelected =
            day.day == selectedDate.day &&
            day.month == selectedDate.month &&
            day.year == selectedDate.year;

        return GestureDetector(
          onTap: () => onDateSelected?.call(day),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Day label (M, T, W, etc.)
              Text(
                dayLabels[index],
                style: AppTextStyles.body(context, FontEngine.google).copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              // Date number in circle with today indicator
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? colors.primary : Colors.transparent,
                      border: !isSelected
                          ? Border.all(
                              color: colors.textSecondary.withValues(
                                alpha: 0.3,
                              ),
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: AppTextStyles.body(context, FontEngine.google)
                            .copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: isSelected
                                  ? colors.surface
                                  : colors.textPrimary,
                            ),
                      ),
                    ),
                  ),
                  // Today indicator dot
                  if (isToday)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? colors.surface : colors.primary,
                          border: Border.all(
                            color: isSelected ? colors.primary : colors.surface,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
