import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HabitSortOption {
  defaultOrder,
  alphabeticalAsc,
  alphabeticalDesc,
  completedLast,
  completedFirst,
  category;

  String get displayName => switch (this) {
        defaultOrder => 'Default',
        alphabeticalAsc => 'Name (A-Z)',
        alphabeticalDesc => 'Name (Z-A)',
        completedLast => 'Incomplete First',
        completedFirst => 'Completed First',
        category => 'Category',
      };

  IconData get icon => switch (this) {
        defaultOrder => Icons.sort,
        alphabeticalAsc => Icons.sort_by_alpha,
        alphabeticalDesc => Icons.sort_by_alpha,
        completedLast => Icons.radio_button_unchecked,
        completedFirst => Icons.check_circle_outline,
        category => Icons.category_outlined,
      };
}

class HabitSortNotifier extends Notifier<HabitSortOption> {
  @override
  HabitSortOption build() => HabitSortOption.defaultOrder;

  void selectSort(HabitSortOption option) => state = option;
}

final habitSortProvider = NotifierProvider<HabitSortNotifier, HabitSortOption>(
  HabitSortNotifier.new,
);
