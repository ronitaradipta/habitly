import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarViewNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void nextMonth() {
    final current = state;
    final next = DateTime(current.year, current.month + 1);
    state = next;
  }

  void previousMonth() {
    final current = state;
    final previous = DateTime(current.year, current.month - 1);
    state = previous;
  }

  void goToMonth(int year, int month) {
    state = DateTime(year, month);
  }

  void goToToday() {
    state = DateTime.now();
  }
}

final calendarViewProvider =
    NotifierProvider.autoDispose<CalendarViewNotifier, DateTime>(
  CalendarViewNotifier.new,
);
