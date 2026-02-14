import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/infrastructure/hive_adapters/habit_adapter.dart';
import 'package:habitly/infrastructure/hive_adapters/theme_mode_adapter.dart';
import 'package:habitly/infrastructure/hive_adapters/user_adapter.dart';
import 'package:habitly/infrastructure/hive_constants.dart';
import 'package:habitly/injection_container.dart' as di;
import 'package:habitly/presentation/pages/add_habit_page.dart';
import 'package:habitly/presentation/pages/edit_habit_page.dart';
import 'package:habitly/presentation/pages/habit_selection_page.dart';
import 'package:habitly/presentation/pages/home_page.dart';
import 'package:habitly/presentation/pages/launch_page.dart';
import 'package:habitly/presentation/pages/login_page.dart';
import 'package:habitly/presentation/pages/onboarding_complete_page.dart';
import 'package:habitly/presentation/pages/register_page.dart';
import 'package:habitly/presentation/pages/reminder_time_page.dart';
import 'package:habitly/presentation/pages/splash_screen.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/providers/theme_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ThemeModeAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(HabitAdapter());

  try {
    await Hive.openBox(HiveConstants.themeBox);
    await Hive.openBox(HiveConstants.authBox);
    await Hive.openBox(HiveConstants.habitBox);
    await Hive.openBox(HiveConstants.registeredUsersBox);
  } catch (e) {
    debugPrint('Hive initialization error: $e');
  }

  di.init();

  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Sizer(
        builder: (context, orientation, screenType) {
          return const MyApp();
        },
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'HabitLy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.light.background,
        primaryColor: AppColors.light.primary,
        colorScheme: ColorScheme.light(
          primary: AppColors.light.primary,
          surface: AppColors.light.surface,
          surfaceContainerLowest: AppColors.light.background,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.dark.background,
        primaryColor: AppColors.dark.primary,
        colorScheme: ColorScheme.dark(
          primary: AppColors.dark.primary,
          surface: AppColors.dark.surface,
          surfaceContainerLowest: AppColors.dark.background,
        ),
      ),
      themeMode: themeMode,

      home: authState.when(
        loading: () => const SplashScreen(),
        data: (user) => user != null ? const HomePage() : const LaunchPage(),
        error: (error, stack) => const LaunchPage(),
      ),
      routes: {
        '/launch': (context) => const LaunchPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/habit-selection': (context) => const HabitSelectionPage(),
        '/reminder-time': (context) => const ReminderTimePage(),
        '/onboarding-complete': (context) => const OnboardingCompletePage(),
        '/home': (context) => const HomePage(),
        '/add-habit': (context) => const AddHabitPage(),
        '/edit-habit': (context) => const EditHabitPage(),
      },
    );
  }
}
