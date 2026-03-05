import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/app_decorations.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/providers/selected_date_provider.dart';
import 'package:habitly/presentation/theme/category_colors.dart';
import 'package:habitly/presentation/theme/icon_mapper.dart';
import 'package:habitly/presentation/widgets/habit/habit_action_menu.dart';
import 'package:habitly/presentation/widgets/shared/dialogs/confirm_dialog.dart';
import 'package:intl/intl.dart';

class _PressScaleFeedback extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _PressScaleFeedback({required this.child, this.onTap});

  @override
  State<_PressScaleFeedback> createState() => _PressScaleFeedbackState();
}

class _PressScaleFeedbackState extends State<_PressScaleFeedback> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}

class HomeHabitTile extends ConsumerWidget {
  final Habit habit;

  const HomeHabitTile({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);

    void toggleCompletion() {
      final selectedDate = ref.read(selectedDateProvider);
      ref
          .read(habitProvider.notifier)
          .toggleCompletion(habit.id, selectedDate);
    }

    void editHabit() {
      Navigator.pushNamed(
        context,
        AppRoutes.editHabit,
        arguments: habit.id,
      );
    }

    Future<void> deleteHabit() async {
      final confirmed = await showConfirmDialog(
        context: context,
        title: 'Delete Habit',
        message: 'Are you sure you want to delete "${habit.name}"?',
        confirmText: 'Delete',
      );

      if (confirmed) {
        await ref.read(habitProvider.notifier).deleteHabit(habit.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Habit "${habit.name}" deleted')),
          );
        }
      }
    }

    void showActionMenu() {
      showHabitActionMenu(
        context: context,
        isCompleted: habit.isCompleted,
        onToggleCompletion: toggleCompletion,
        onEdit: editHabit,
        onDelete: deleteHabit,
      );
    }

    String buildFrequencyLabel() {
      String label;
      if (habit.frequency == HabitFrequency.customDays) {
        final n = habit.customDays ?? 2;
        label = 'Every $n day${n > 1 ? 's' : ''}';
      } else {
        label = habit.frequency.displayName;
      }
      if (habit.endDate != null) {
        label += ' · Until ${DateFormat('MMM d').format(habit.endDate!)}';
      }
      return label;
    }

    Widget buildSwipeBackground() {
      return Container(
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Icon(Icons.check, color: colors.surface, size: 28),
      );
    }

    Widget buildDeleteBackground() {
      return Container(
        decoration: BoxDecoration(
          color: colors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: colors.surface, size: 28),
      );
    }

    return _PressScaleFeedback(
      onTap: toggleCompletion,
      child: Dismissible(
        key: Key(habit.id),
        direction: DismissDirection.horizontal,
        dismissThresholds: const {
          DismissDirection.startToEnd: 0.6,
          DismissDirection.endToStart: 0.6,
        },
        background: buildSwipeBackground(),
        secondaryBackground: buildDeleteBackground(),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            toggleCompletion();
          } else if (direction == DismissDirection.endToStart) {
            deleteHabit();
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: habit.isCompleted
                ? colors.primary.withValues(alpha: 0.1)
                : colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: habit.isCompleted
                    ? colors.primary
                    : colors.textSecondary.withValues(alpha: 0.3),
                width: 4,
              ),
            ),
            boxShadow: const [AppDecorations.cardShadow],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Habit icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: habit.category != null
                        ? Color(habit.category!.lightColorValue)
                        : colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    IconMapper.toIconData(habit.iconName),
                    color: habit.category != null
                        ? Color(habit.category!.primaryColorValue)
                        : colors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Habit details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.name,
                        style: AppTextStyles.body(context).copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: colors.textPrimary,
                          decoration: habit.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Frequency subtitle
                      Row(
                        children: [
                          Icon(
                            habit.frequency.icon,
                            size: 12,
                            color: colors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            buildFrequencyLabel(),
                            style: AppTextStyles.caption(context).copyWith(
                              color: colors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      if (habit.hasReminder && habit.reminderTime != null)
                        Row(
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              size: 12,
                              color: habit.isCompleted
                                  ? colors.textSecondary.withValues(alpha: 0.7)
                                  : colors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              habit.formattedReminderTime,
                              style: AppTextStyles.caption(context).copyWith(
                                color: habit.isCompleted
                                    ? colors.textSecondary.withValues(alpha: 0.7)
                                    : colors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Checkbox
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    toggleCompletion();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: habit.isCompleted ? colors.primary : colors.surface,
                      border: Border.all(
                        color: habit.isCompleted
                            ? colors.primary
                            : colors.textSecondary.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: habit.isCompleted
                        ? Icon(Icons.check, size: 18, color: colors.surface)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                // More options button
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: showActionMenu,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.more_vert,
                      color: colors.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
