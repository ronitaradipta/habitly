import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/usecases/add_habit_use_case.dart';
import 'package:habitly/domain/usecases/check_email_registered_use_case.dart';
import 'package:habitly/domain/usecases/delete_habit_use_case.dart';
import 'package:habitly/domain/usecases/get_current_user_use_case.dart';
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

// Auth use cases
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

// Theme use cases
final getThemeUseCaseProvider = Provider((_) => di.getIt<GetThemeUseCase>());
final saveThemeUseCaseProvider = Provider((_) => di.getIt<SaveThemeUseCase>());

// Habit use cases
final addHabitUseCaseProvider = Provider((_) => di.getIt<AddHabitUseCase>());
final deleteHabitUseCaseProvider = Provider(
  (_) => di.getIt<DeleteHabitUseCase>(),
);
final getHabitsUseCaseProvider = Provider(
  (_) => di.getIt<GetHabitsUseCase>(),
);
final updateHabitUseCaseProvider = Provider(
  (_) => di.getIt<UpdateHabitUseCase>(),
);
final setupOnboardingHabitsUseCaseProvider = Provider(
  (_) => di.getIt<SetupOnboardingHabitsUseCase>(),
);
final updateHabitsReminderUseCaseProvider = Provider(
  (_) => di.getIt<UpdateHabitsReminderUseCase>(),
);
final toggleHabitCompletionUseCaseProvider = Provider(
  (_) => di.getIt<ToggleHabitCompletionUseCase>(),
);
