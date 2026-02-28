import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/category.dart';

class OnboardingCategoryState {
  final Set<HabitCategory> selectedCategories;

  const OnboardingCategoryState({this.selectedCategories = const {}});

  bool get hasSelection => selectedCategories.isNotEmpty;

  bool isSelected(HabitCategory category) =>
      selectedCategories.contains(category);

  bool get isMaxSelected => selectedCategories.length >= 3;

  OnboardingCategoryState copyWith({Set<HabitCategory>? selectedCategories}) {
    return OnboardingCategoryState(
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }
}

class OnboardingCategoryNotifier extends Notifier<OnboardingCategoryState> {
  @override
  OnboardingCategoryState build() => const OnboardingCategoryState();

  void toggleCategory(HabitCategory category) {
    final current = Set<HabitCategory>.from(state.selectedCategories);
    if (current.contains(category)) {
      current.remove(category);
    } else {
      if (current.length >= 3) return;
      current.add(category);
    }
    state = state.copyWith(selectedCategories: current);
  }
}

final onboardingCategoryProvider =
    NotifierProvider.autoDispose<OnboardingCategoryNotifier, OnboardingCategoryState>(
      OnboardingCategoryNotifier.new,
    );
