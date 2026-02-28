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

class HomeHabitTile extends ConsumerStatefulWidget {
  final Habit habit;

  const HomeHabitTile({super.key, required this.habit});

  @override
  ConsumerState<HomeHabitTile> createState() => _HomeHabitTileState();
}

class _HomeHabitTileState extends ConsumerState<HomeHabitTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  void _toggleCompletion() {
    final selectedDate = ref.read(selectedDateProvider);
    ref
        .read(habitProvider.notifier)
        .toggleCompletion(widget.habit.id, selectedDate);
  }

  void _editHabit() {
    Navigator.pushNamed(
      context,
      AppRoutes.editHabit,
      arguments: widget.habit.id,
    );
  }

  Future<void> _deleteHabit() async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Delete Habit',
      message: 'Are you sure you want to delete "${widget.habit.name}"?',
      confirmText: 'Delete',
    );

    if (confirmed) {
      await ref.read(habitProvider.notifier).deleteHabit(widget.habit.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Habit "${widget.habit.name}" deleted')),
        );
      }
    }
  }

  IconData _getHabitIcon() {
    return IconMapper.toIconData(widget.habit.iconName);
  }

  String _buildFrequencyLabel(Habit habit) {
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

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _toggleCompletion,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dismissible(
          key: Key(widget.habit.id),
          direction: DismissDirection.horizontal,
          dismissThresholds: const {
            DismissDirection.startToEnd: 0.6,
            DismissDirection.endToStart: 0.6,
          },
          background: _buildSwipeBackground(context, colors),
          secondaryBackground: _buildDeleteBackground(context, colors),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              _toggleCompletion();
            } else if (direction == DismissDirection.endToStart) {
              _deleteHabit();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: widget.habit.isCompleted
                  ? colors.primary.withValues(alpha: 0.1)
                  : colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: widget.habit.isCompleted
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
                      color: widget.habit.category != null
                          ? Color(widget.habit.category!.lightColorValue)
                          : colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getHabitIcon(),
                      color: widget.habit.category != null
                          ? Color(widget.habit.category!.primaryColorValue)
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
                          widget.habit.name,
                          style: AppTextStyles.body(context).copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: colors.textPrimary,
                            decoration: widget.habit.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Frequency subtitle
                        Row(
                          children: [
                            Icon(
                              widget.habit.frequency.icon,
                              size: 12,
                              color: colors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _buildFrequencyLabel(widget.habit),
                              style: AppTextStyles.caption(context).copyWith(
                                color: colors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        if (widget.habit.hasReminder &&
                            widget.habit.reminderTime != null)
                          Row(
                            children: [
                              Icon(
                                Icons.notifications_outlined,
                                size: 12,
                                color: widget.habit.isCompleted
                                    ? colors.textSecondary.withValues(
                                        alpha: 0.7,
                                      )
                                    : colors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.habit.formattedReminderTime,
                                style: AppTextStyles.caption(context).copyWith(
                                  color: widget.habit.isCompleted
                                      ? colors.textSecondary.withValues(
                                          alpha: 0.7,
                                        )
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
                      _toggleCompletion();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.habit.isCompleted
                            ? colors.primary
                            : colors.surface,
                        border: Border.all(
                          color: widget.habit.isCompleted
                              ? colors.primary
                              : colors.textSecondary.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: widget.habit.isCompleted
                          ? Icon(Icons.check, size: 18, color: colors.surface)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // More options button
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _showActionMenu(context),
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
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, AppColors colors) {
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

  Widget _buildDeleteBackground(BuildContext context, AppColors colors) {
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

  void _showActionMenu(BuildContext context) {
    showHabitActionMenu(
      context: context,
      isCompleted: widget.habit.isCompleted,
      onToggleCompletion: _toggleCompletion,
      onEdit: _editHabit,
      onDelete: _deleteHabit,
    );
  }
}
