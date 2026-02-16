import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/repositories/auth_repository.dart';
import 'package:habitly/domain/repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  LoginUseCase(this._userRepository, this._authRepository);

  Future<User> call({required String email, required String password}) async {
    final normalizedEmail = email.toLowerCase();

    await _authRepository.signIn(email: normalizedEmail, password: password);

    final user = await _userRepository.getCurrentUser();

    if (user == null) {
      throw Exception('User profile not found.');
    }

    final updatedUser = user.copyWith(loggedInAt: DateTime.now());

    await _userRepository.saveUser(updatedUser);

    return updatedUser;
  }
}
