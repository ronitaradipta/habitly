import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/usecases/check_email_registered_use_case.dart';
import 'package:habitly/domain/usecases/get_current_user_use_case.dart';
import 'package:habitly/domain/usecases/login_use_case.dart';
import 'package:habitly/domain/usecases/logout_use_case.dart';
import 'package:habitly/domain/usecases/mark_onboarding_complete_use_case.dart';
import 'package:habitly/domain/usecases/register_use_case.dart';
import 'package:habitly/injection_container.dart' as di;

class AuthNotifier extends AsyncNotifier<User?> {
  late final _getCurrentUserUseCase = di.getIt<GetCurrentUserUseCase>();
  late final _loginUseCase = di.getIt<LoginUseCase>();
  late final _registerUseCase = di.getIt<RegisterUseCase>();
  late final _logoutUseCase = di.getIt<LogoutUseCase>();
  late final _markOnboardingCompleteUseCase = di
      .getIt<MarkOnboardingCompleteUseCase>();
  late final _checkEmailRegisteredUseCase = di
      .getIt<CheckEmailRegisteredUseCase>();

  @override
  Future<User?> build() async {
    return _getCurrentUserUseCase();
  }

  Future<bool> isEmailRegistered(String email) async {
    return _checkEmailRegisteredUseCase(email);
  }

  Future<void> register({
    required String email,
    required String fullName,
    required String mobile,
    required String gender,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _registerUseCase(
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
      return _loginUseCase(email);
    });
  }

  Future<void> markOnboardingComplete() async {
    final currentUser = state.value;
    if (currentUser == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _markOnboardingCompleteUseCase(currentUser);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _logoutUseCase();
      return null;
    });
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

final currentUserEmailProvider = Provider<String?>((ref) {
  final authAsync = ref.watch(authProvider);
  return authAsync.value?.email;
});
