import 'package:get_it/get_it.dart';
import 'package:habitly/data/datasources/hive_data_source.dart';
import 'package:habitly/data/datasources/local_data_source.dart';
import 'package:habitly/data/repositories/habit_repository_impl.dart';
import 'package:habitly/data/repositories/theme_repository_impl.dart';
import 'package:habitly/data/repositories/user_repository_impl.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';
import 'package:habitly/domain/repositories/theme_repository.dart';
import 'package:habitly/domain/repositories/user_repository.dart';
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
import 'package:habitly/domain/usecases/update_habit_use_case.dart';

final getIt = GetIt.instance;

void init() {
  // Data Sources
  getIt.registerLazySingleton<LocalDataSource>(() => HiveDataSource());

  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(getIt()),
  );

  // HabitRepository is user-scoped - cache instances per userEmail
  final Map<String, HabitRepository> habitRepositoryCache = {};

  HabitRepository getOrCreateHabitRepository(String userEmail) {
    return habitRepositoryCache.putIfAbsent(
      userEmail,
      () => HabitRepositoryImpl(getIt(), userEmail),
    );
  }

  getIt.registerFactoryParam<HabitRepository, String, void>(
    (userEmail, _) => getOrCreateHabitRepository(userEmail),
  );

  // Use Cases (Auth - singleton)
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => MarkOnboardingCompleteUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckEmailRegisteredUseCase(getIt()));

  // Use Cases (Theme - singleton)
  getIt.registerLazySingleton(() => GetThemeUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveThemeUseCase(getIt()));

  // Use Cases (Habit - user-scoped, require userEmail parameter)
  getIt.registerFactoryParam<AddHabitUseCase, String, void>(
    (userEmail, _) =>
        AddHabitUseCase(getIt<HabitRepository>(param1: userEmail)),
  );
  getIt.registerFactoryParam<DeleteHabitUseCase, String, void>(
    (userEmail, _) =>
        DeleteHabitUseCase(getIt<HabitRepository>(param1: userEmail)),
  );
  getIt.registerFactoryParam<GetHabitsUseCase, String, void>(
    (userEmail, _) =>
        GetHabitsUseCase(getIt<HabitRepository>(param1: userEmail)),
  );
  getIt.registerFactoryParam<UpdateHabitUseCase, String, void>(
    (userEmail, _) =>
        UpdateHabitUseCase(getIt<HabitRepository>(param1: userEmail)),
  );
}
