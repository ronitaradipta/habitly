import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedDateState {
  final DateTime date;

  SelectedDateState({DateTime? date}) : date = date ?? DateTime.now();

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  SelectedDateState copyWith({DateTime? date}) {
    return SelectedDateState(date: date ?? this.date);
  }
}

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void selectDate(DateTime date) {
    state = date;
  }

  void resetToToday() {
    state = DateTime.now();
  }
}

/// Provider for selected date state
final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);
