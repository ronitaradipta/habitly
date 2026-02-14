import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/repositories/user_repository.dart';

class RegisterUseCase {
  final UserRepository _userRepository;

  RegisterUseCase(this._userRepository);

  Future<User> call({
    required String email,
    required String fullName,
    required String mobile,
    required String gender,
  }) async {
    final normalizedEmail = email.toLowerCase();

    final user = User(
      email: normalizedEmail,
      fullName: fullName,
      mobile: mobile,
      gender: gender,
      loggedInAt: DateTime.now(),
      hasCompletedOnboarding: false,
    );

    await _userRepository.saveRegisteredUser(user);

    await _userRepository.saveCurrentUser(user);

    return user;
  }
}
