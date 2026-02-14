import 'package:habitly/domain/repositories/user_repository.dart';

class CheckEmailRegisteredUseCase {
  final UserRepository _userRepository;

  CheckEmailRegisteredUseCase(this._userRepository);

  Future<bool> call(String email) async {
    return _userRepository.isEmailRegistered(email.toLowerCase());
  }
}
