import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:habitly/data/repositories/firebase_auth_repository.dart';
import 'package:habitly/data/repositories/firestore_theme_repository.dart';
import 'package:habitly/data/repositories/firestore_habit_repository.dart';
import 'package:habitly/data/repositories/firestore_user_repository.dart';
import 'package:habitly/domain/repositories/auth_repository.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';
import 'package:habitly/domain/repositories/theme_repository.dart';
import 'package:habitly/domain/repositories/user_repository.dart';
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

final getIt = GetIt.instance;

void init() {
  // Firebase instances
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(auth: getIt()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => FirestoreUserRepository(firestore: getIt(), auth: getIt()),
  );
  getIt.registerLazySingleton<ThemeRepository>(
    () => FirestoreThemeRepository(firestore: getIt(), auth: getIt()),
  );
  getIt.registerLazySingleton<HabitRepository>(
    () => FirestoreHabitRepository(firestore: getIt(), auth: getIt()),
  );

  // Use Cases - Auth
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => MarkOnboardingCompleteUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckEmailRegisteredUseCase(getIt()));

  // Use Cases - Theme
  getIt.registerLazySingleton(() => GetThemeUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveThemeUseCase(getIt()));

  // Use Cases - Habit
  getIt.registerLazySingleton(() => AddHabitUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteHabitUseCase(getIt()));
  getIt.registerLazySingleton(() => GetHabitsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetHabitsByDateUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateHabitUseCase(getIt()));
  getIt.registerLazySingleton(() => SetupOnboardingHabitsUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateHabitsReminderUseCase(getIt()));
  getIt.registerLazySingleton(() => ToggleHabitCompletionUseCase(getIt()));
}
