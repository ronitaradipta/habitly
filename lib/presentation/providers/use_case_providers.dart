import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/usecases/add_habit_use_case.dart';
import 'package:habitly/domain/usecases/check_email_registered_use_case.dart';
import 'package:habitly/domain/usecases/delete_habit_use_case.dart';
import 'package:habitly/domain/usecases/get_current_user_use_case.dart';
import 'package:habitly/domain/usecases/get_habits_by_date_use_case.dart';
import 'package:habitly/domain/usecases/get_habits_use_case.dart';
import 'package:habitly/domain/usecases/get_theme_use_case.dart';
import 'package:habitly/domain/usecases/login_use_case.dart';
import 'package:habitly/domain/usecases/logout_use_case.dart';
import 'package:habitly/domain/usecases/mark_onboarding_complete_use_case.dart';
import 'package:habitly/domain/usecases/register_use_case.dart';
import 'package:habitly/domain/usecases/save_theme_use_case.dart';
import 'package:habitly/domain/usecases/setup_onboarding_habits_use_case.dart';
import 'package:habitly/domain/usecases/toggle_habit_completion_use_case.dart';
import 'package:habitly/domain/usecases/update_habit_use_case.dart';
import 'package:habitly/domain/usecases/update_habits_reminder_use_case.dart';
import 'package:habitly/injection_container.dart' as di;

// Auth use cases (singleton)
final getCurrentUserUseCaseProvider = Provider(
  (_) => di.getIt<GetCurrentUserUseCase>(),
);
final loginUseCaseProvider = Provider((_) => di.getIt<LoginUseCase>());
final registerUseCaseProvider = Provider((_) => di.getIt<RegisterUseCase>());
final logoutUseCaseProvider = Provider((_) => di.getIt<LogoutUseCase>());
final markOnboardingCompleteUseCaseProvider = Provider(
  (_) => di.getIt<MarkOnboardingCompleteUseCase>(),
);
final checkEmailRegisteredUseCaseProvider = Provider(
  (_) => di.getIt<CheckEmailRegisteredUseCase>(),
);

// Theme use cases (singleton)
final getThemeUseCaseProvider = Provider((_) => di.getIt<GetThemeUseCase>());
final saveThemeUseCaseProvider = Provider((_) => di.getIt<SaveThemeUseCase>());

// Habit use cases (user-scoped)
final addHabitUseCaseProvider = Provider.family<AddHabitUseCase, String>(
  (_, email) => di.getIt<AddHabitUseCase>(param1: email),
);
final deleteHabitUseCaseProvider = Provider.family<DeleteHabitUseCase, String>(
  (_, email) => di.getIt<DeleteHabitUseCase>(param1: email),
);
final getHabitsUseCaseProvider = Provider.family<GetHabitsUseCase, String>(
  (_, email) => di.getIt<GetHabitsUseCase>(param1: email),
);
final getHabitsByDateUseCaseProvider =
    Provider.family<GetHabitsByDateUseCase, String>(
      (_, email) => di.getIt<GetHabitsByDateUseCase>(param1: email),
    );
final updateHabitUseCaseProvider = Provider.family<UpdateHabitUseCase, String>(
  (_, email) => di.getIt<UpdateHabitUseCase>(param1: email),
);
final setupOnboardingHabitsUseCaseProvider =
    Provider.family<SetupOnboardingHabitsUseCase, String>(
      (_, email) => di.getIt<SetupOnboardingHabitsUseCase>(param1: email),
    );
final updateHabitsReminderUseCaseProvider =
    Provider.family<UpdateHabitsReminderUseCase, String>(
      (_, email) => di.getIt<UpdateHabitsReminderUseCase>(param1: email),
    );
final toggleHabitCompletionUseCaseProvider =
    Provider.family<ToggleHabitCompletionUseCase, String>(
      (_, email) => di.getIt<ToggleHabitCompletionUseCase>(param1: email),
    );
