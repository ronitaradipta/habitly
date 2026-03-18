import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/presentation/providers/habit_form_provider.dart';
import 'package:habitly/presentation/widgets/habit/habit_form.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';

class EditHabitPage extends ConsumerWidget {
  const EditHabitPage({super.key});

  void _navigateBackWithError(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Navigator.canPop(context)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        Navigator.pop(context);
      }
    });
  }

  Widget _buildLoadingScaffold() {
    return const ThemeScaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitId = ModalRoute.of(context)?.settings.arguments as String?;

    if (habitId == null) {
      _navigateBackWithError(context, 'Error: Habit not found');
      return _buildLoadingScaffold();
    }

    final habitsAsync = ref.watch(habitProvider);

    return habitsAsync.when(
      skipLoadingOnReload: true,
      loading: () => _buildLoadingScaffold(),
      error: (error, stack) {
        _navigateBackWithError(context, 'Error loading habit: $error');
        return _buildLoadingScaffold();
      },
      data: (habits) {
        final habit = habits.where((h) => h.id == habitId).firstOrNull;

        if (habit == null) {
          _navigateBackWithError(context, 'Error: Habit not found');
          return _buildLoadingScaffold();
        }

        return HabitForm(mode: FormMode.edit, initialHabit: habit);
      },
    );
  }
}
