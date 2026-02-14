import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository _userRepository;

  LoginUseCase(this._userRepository);

  Future<User> call(String email) async {
    final normalizedEmail = email.toLowerCase();

    final registeredUser = await _userRepository.getRegisteredUser(
      normalizedEmail,
    );

    if (registeredUser == null) {
      throw Exception('Account does not exist. Please register first.');
    }

    final updatedUser = registeredUser.copyWith(loggedInAt: DateTime.now());

    await _userRepository.saveCurrentUser(updatedUser);
    await _userRepository.saveRegisteredUser(updatedUser);

    return updatedUser;
  }
}
