import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/utils/analytics_calculator.dart';
import 'package:habitly/domain/entities/progress_data.dart';
import 'package:habitly/presentation/providers/filtered_habits_provider.dart';
import 'package:habitly/presentation/providers/selected_category_provider.dart';

final progressProvider = Provider<ProgressData>((ref) {
  final dateFiltered = ref.watch(dateFilteredHabitsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  final habitsAsync = dateFiltered.whenData((habits) {
    if (selectedCategory == null) return habits;
    return habits.where((h) => h.category == selectedCategory).toList();
  });

  return habitsAsync.when(
    loading: () => const ProgressData(
      completedCount: 0,
      totalCount: 0,
      percentage: 0,
      motivationalMessage: 'Loading...',
    ),
    error: (_, _) => const ProgressData(
      completedCount: 0,
      totalCount: 0,
      percentage: 0,
      motivationalMessage: 'Error loading habits',
    ),
    data: (habits) {
      final completedCount = habits.where((h) => h.isCompleted).length;
      final totalCount = habits.length;
      final percentage =
          totalCount > 0 ? (completedCount / totalCount * 100).round() : 0;

      return ProgressData(
        completedCount: completedCount,
        totalCount: totalCount,
        percentage: percentage,
        motivationalMessage: getMotivationalMessage(percentage),
      );
    },
  );
});
