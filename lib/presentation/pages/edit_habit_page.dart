import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/presentation/widgets/habit/habit_form.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/core/theme/app_colors.dart';

class EditHabitPage extends ConsumerWidget {
  const EditHabitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final habitId = ModalRoute.of(context)?.settings.arguments as String?;

    if (habitId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Habit not found')),
          );
          Navigator.pop(context);
        }
      });
      return Scaffold(
        backgroundColor: colors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final habitsAsync = ref.watch(habitProvider);

    return habitsAsync.when(
      loading: () => Scaffold(
        backgroundColor: colors.background,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Navigator.canPop(context)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading habit: $error')),
            );
            Navigator.pop(context);
          }
        });
        return Scaffold(
          backgroundColor: colors.background,
          body: const Center(child: CircularProgressIndicator()),
        );
      },
      data: (habits) {
        final habit = habits.where((h) => h.id == habitId).firstOrNull;

        if (habit == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.canPop(context)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error: Habit not found')),
              );
              Navigator.pop(context);
            }
          });
          return Scaffold(
            backgroundColor: colors.background,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return HabitForm(mode: FormMode.edit, initialHabit: habit);
      },
    );
  }
}
