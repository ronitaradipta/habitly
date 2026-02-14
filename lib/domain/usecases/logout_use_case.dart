import 'package:habitly/domain/repositories/user_repository.dart';

class LogoutUseCase {
  final UserRepository _userRepository;

  LogoutUseCase(this._userRepository);

  Future<void> call() async {
    await _userRepository.removeCurrentUser();
  }
}
