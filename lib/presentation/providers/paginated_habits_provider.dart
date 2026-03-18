import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/app_constants.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/paginated_list.dart';
import 'package:habitly/presentation/providers/sorted_habits_provider.dart';

final paginatedHabitsProvider = NotifierProvider<PaginatedHabitsNotifier,
    AsyncValue<PaginatedList<Habit>>>(PaginatedHabitsNotifier.new);

class PaginatedHabitsNotifier
    extends Notifier<AsyncValue<PaginatedList<Habit>>> {
  @override
  AsyncValue<PaginatedList<Habit>> build() {
    final sorted = ref.watch(sortedHabitsProvider);
    return sorted.whenData((allHabits) => _paginate(allHabits, 0));
  }

  void loadMore() {
    final current = state;
    if (current is! AsyncData<PaginatedList<Habit>>) return;

    final paginated = current.value;
    if (!paginated.hasMore) return;

    final sorted = ref.read(sortedHabitsProvider);
    if (sorted is! AsyncData<List<Habit>>) return;

    final nextPage = paginated.currentPage + 1;
    state = AsyncData(_paginate(sorted.value, nextPage));
  }

  PaginatedList<Habit> _paginate(List<Habit> allHabits, int page) {
    final end = (page + 1) * AppPagination.defaultPageSize;
    final visibleCount = end.clamp(0, allHabits.length);
    return PaginatedList(
      items: allHabits.sublist(0, visibleCount),
      totalCount: allHabits.length,
      hasMore: visibleCount < allHabits.length,
      currentPage: page,
    );
  }
}
