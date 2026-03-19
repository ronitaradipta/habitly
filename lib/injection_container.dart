import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:habitly/data/datasources/auth_datasource.dart';
import 'package:habitly/data/datasources/habit_datasource.dart';
import 'package:habitly/data/datasources/theme_datasource.dart';
import 'package:habitly/data/datasources/user_datasource.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habitly/core/services/ai_chat_service.dart';
import 'package:habitly/core/services/ai_habit_generator_service.dart';
import 'package:habitly/core/services/ai_insights_service.dart';
import 'package:habitly/core/services/groq_api_client.dart';
import 'package:habitly/core/services/local_notification_service.dart';
import 'package:habitly/data/repositories/groq_ai_chat_repository.dart';
import 'package:habitly/data/repositories/groq_ai_habit_generator_repository.dart';
import 'package:habitly/data/repositories/groq_ai_insights_repository.dart';
import 'package:habitly/domain/repositories/ai_chat_repository.dart';
import 'package:habitly/domain/repositories/ai_habit_generator_repository.dart';
import 'package:habitly/domain/repositories/ai_insights_repository.dart';
import 'package:habitly/domain/repositories/chat_history_repository.dart';
import 'package:habitly/data/datasources/chat_history_datasource.dart';
import 'package:habitly/data/repositories/firestore_chat_history_repository.dart';
import 'package:habitly/domain/usecases/clear_chat_history_use_case.dart';
import 'package:habitly/domain/usecases/get_chat_history_use_case.dart';
import 'package:habitly/domain/usecases/save_chat_message_use_case.dart';
import 'package:habitly/domain/usecases/generate_ai_insights_use_case.dart';
import 'package:habitly/domain/usecases/generate_habits_use_case.dart';
import 'package:habitly/domain/usecases/send_chat_message_use_case.dart';
import 'package:habitly/domain/usecases/update_habits_reminder_use_case.dart';

final getIt = GetIt.instance;

void init() {
  // Firebase instances
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  // Datasources
  getIt.registerLazySingleton<AuthDatasource>(
    () => FirebaseAuthDatasource(auth: getIt()),
  );
  getIt.registerLazySingleton<HabitDatasource>(
    () => FirestoreHabitDatasource(firestore: getIt()),
  );
  getIt.registerLazySingleton<UserDatasource>(
    () => FirestoreUserDatasource(firestore: getIt()),
  );
  getIt.registerLazySingleton<ThemeDatasource>(
    () => FirestoreThemeDatasource(firestore: getIt()),
  );
  getIt.registerLazySingleton<ChatHistoryDatasource>(
    () => FirestoreChatHistoryDatasource(firestore: getIt()),
  );

  // Plugins
  getIt.registerLazySingleton(() => FlutterLocalNotificationsPlugin());

  // Services
  getIt.registerLazySingleton(() => LocalNotificationService(plugin: getIt()));
  getIt.registerLazySingleton(() => GroqApiClient());
  getIt.registerLazySingleton(() => AiInsightsService(client: getIt()));
  getIt.registerLazySingleton(
    () => AiChatService(client: getIt(), addHabitUseCase: getIt()),
  );
  getIt.registerLazySingleton(() => AiHabitGeneratorService(client: getIt()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(datasource: getIt()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => FirestoreUserRepository(datasource: getIt(), authDatasource: getIt()),
  );
  getIt.registerLazySingleton<ThemeRepository>(
    () =>
        FirestoreThemeRepository(datasource: getIt(), authDatasource: getIt()),
  );
  getIt.registerLazySingleton<HabitRepository>(
    () =>
        FirestoreHabitRepository(datasource: getIt(), authDatasource: getIt()),
  );
  getIt.registerLazySingleton<AiInsightsRepository>(
    () => GroqAiInsightsRepository(getIt()),
  );
  getIt.registerLazySingleton<AiChatRepository>(
    () => GroqAiChatRepository(getIt()),
  );
  getIt.registerLazySingleton<AiHabitGeneratorRepository>(
    () => GroqAiHabitGeneratorRepository(getIt()),
  );
  getIt.registerLazySingleton<ChatHistoryRepository>(
    () => FirestoreChatHistoryRepository(
      datasource: getIt(),
      authDatasource: getIt(),
    ),
  );

  // Use Cases - Auth
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
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
  getIt.registerLazySingleton(() => UpdateHabitUseCase(getIt()));
  getIt.registerLazySingleton(() => SetupOnboardingHabitsUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateHabitsReminderUseCase(getIt()));
  getIt.registerLazySingleton(() => ToggleHabitCompletionUseCase(getIt()));

  // Use Cases - AI
  getIt.registerLazySingleton(() => GenerateAiInsightsUseCase(getIt()));
  getIt.registerLazySingleton(() => SendChatMessageUseCase(getIt()));
  getIt.registerLazySingleton(() => GenerateHabitsUseCase(getIt()));

  // Use Cases - Chat History
  getIt.registerLazySingleton(() => GetChatHistoryUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveChatMessageUseCase(getIt()));
  getIt.registerLazySingleton(() => ClearChatHistoryUseCase(getIt()));
}
