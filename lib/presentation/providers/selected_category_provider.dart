import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/category.dart';

class SelectedCategoryNotifier extends Notifier<HabitCategory?> {
  @override
  HabitCategory? build() => null;

  void selectCategory(HabitCategory? category) => state = category;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, HabitCategory?>(
  SelectedCategoryNotifier.new,
);
