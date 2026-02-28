import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/core/utils/date_utils.dart';
import 'package:habitly/presentation/providers/calendar_view_provider.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CustomCalendar extends ConsumerWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onDateSelected;

  const CustomCalendar({
    super.key,
    required this.selectedDate,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final viewMonth = ref.watch(calendarViewProvider);

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(viewMonth.year, viewMonth.month, 1);
    final lastDayOfMonth = DateTime(viewMonth.year, viewMonth.month + 1, 0);

    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          ref
                              .read(calendarViewProvider.notifier)
                              .previousMonth();
                        },
                        icon: Icon(
                          Icons.chevron_left,
                          color: colors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(calendarViewProvider.notifier).goToToday();
                          onDateSelected?.call(now);
                        },
                        child: Column(
                          children: [
                            Text(
                              DateFormat('MMMM yyyy').format(viewMonth),
                              style: AppTextStyles.heading(
                                context,
                              ).copyWith(fontSize: 16.sp),
                            ),
                            if (!AppDateUtils.isSameDay(viewMonth, now))
                              Text(
                                'Tap to go to today',
                                style: AppTextStyles.caption(context).copyWith(
                                  color: colors.textSecondary,
                                  fontSize: 14.sp,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(calendarViewProvider.notifier).nextMonth();
                        },
                        icon: Icon(
                          Icons.chevron_right,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: dayLabels.map((label) {
                      return SizedBox(
                        width: 40,
                        child: Center(
                          child: Text(
                            label.substring(0, 1),
                            style: AppTextStyles.caption(context).copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  for (int week = 0; week < 6; week++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int day = 0; day < 7; day++)
                          _buildDayCell(
                            context: context,
                            week: week,
                            day: day,
                            firstWeekday: firstWeekday,
                            daysInMonth: daysInMonth,
                            viewMonth: viewMonth,
                            selectedDate: selectedDate,
                            now: now,
                            onDateSelected: onDateSelected,
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell({
    required BuildContext context,
    required int week,
    required int day,
    required int firstWeekday,
    required int daysInMonth,
    required DateTime viewMonth,
    required DateTime selectedDate,
    required DateTime now,
    required ValueChanged<DateTime>? onDateSelected,
  }) {
    final colors = AppColors.of(context);
    final dayNumber = week * 7 + day - (firstWeekday - 1);

    if (dayNumber < 1 || dayNumber > daysInMonth) {
      return const SizedBox(width: 40, height: 40);
    }

    final cellDate = DateTime(viewMonth.year, viewMonth.month, dayNumber);
    final isSelected = AppDateUtils.isSameDay(cellDate, selectedDate);
    final isToday = AppDateUtils.isSameDay(cellDate, now);

    return GestureDetector(
      onTap: () => onDateSelected?.call(cellDate),
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? colors.primary : Colors.transparent,
          border: !isSelected
              ? Border.all(color: colors.border, width: 1)
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                dayNumber.toString(),
                style: AppTextStyles.body(context).copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? colors.surface : colors.textPrimary,
                ),
              ),
            ),
            if (isToday && !isSelected)
              Positioned(
                bottom: 2,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
