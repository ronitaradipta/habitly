import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/repositories/user_repository.dart';
import 'package:habitly/domain/usecases/check_email_registered_use_case.dart';
import 'package:habitly/domain/usecases/login_use_case.dart';
import 'package:habitly/domain/usecases/logout_use_case.dart';
import 'package:habitly/domain/usecases/mark_onboarding_complete_use_case.dart';
import 'package:habitly/domain/usecases/register_use_case.dart';
import 'package:habitly/injection_container.dart' as di;

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final userRepository = di.getIt<UserRepository>();
    return userRepository.getCurrentUser();
  }

  Future<bool> isEmailRegistered(String email) async {
    final useCase = di.getIt<CheckEmailRegisteredUseCase>();
    return useCase(email);
  }

  Future<void> register({
    required String email,
    required String fullName,
    required String mobile,
    required String gender,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = di.getIt<RegisterUseCase>();
      return useCase(
        email: email,
        fullName: fullName,
        mobile: mobile,
        gender: gender,
      );
    });
  }

  Future<void> login(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = di.getIt<LoginUseCase>();
      return useCase(email);
    });
  }

  Future<void> markOnboardingComplete() async {
    final currentUser = state.value;
    if (currentUser == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = di.getIt<MarkOnboardingCompleteUseCase>();
      return useCase(currentUser);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = di.getIt<LogoutUseCase>();
      await useCase();
      return null;
    });
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authAsync = ref.watch(authProvider);
  return authAsync.value != null;
});

final currentUserEmailProvider = Provider<String?>((ref) {
  final authAsync = ref.watch(authProvider);
  return authAsync.value?.email;
});

final hasCompletedOnboardingProvider = Provider<bool>((ref) {
  final authAsync = ref.watch(authProvider);
  return authAsync.value?.hasCompletedOnboarding ?? false;
});
