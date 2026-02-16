import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/repositories/auth_repository.dart';
import 'package:habitly/domain/repositories/user_repository.dart';

class RegisterUseCase {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  RegisterUseCase(this._userRepository, this._authRepository);

  Future<User> call({
    required String email,
    required String fullName,
    required String mobile,
    required String gender,
    required String password,
  }) async {
    final normalizedEmail = email.toLowerCase();

    await _authRepository.signUp(email: normalizedEmail, password: password);

    final user = User(
      email: normalizedEmail,
      fullName: fullName,
      mobile: mobile,
      gender: gender,
      loggedInAt: DateTime.now(),
      hasCompletedOnboarding: false,
    );

    await _userRepository.saveUser(user);

    return user;
  }
}
