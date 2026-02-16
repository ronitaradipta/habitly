import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/presentation/providers/use_case_providers.dart';

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    return ref.read(getCurrentUserUseCaseProvider)();
  }

  Future<bool> isEmailRegistered(String email) async {
    return ref.read(checkEmailRegisteredUseCaseProvider)(email);
  }

  Future<void> register({
    required String email,
    required String fullName,
    required String mobile,
    required String gender,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(registerUseCaseProvider)(
        email: email,
        fullName: fullName,
        mobile: mobile,
        gender: gender,
        password: password,
      );
    });
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(loginUseCaseProvider)(email: email, password: password);
    });
  }

  Future<void> markOnboardingComplete() async {
    final currentUser = state.value;
    if (currentUser == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(markOnboardingCompleteUseCaseProvider)(currentUser);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(logoutUseCaseProvider)();
      return null;
    });
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);
