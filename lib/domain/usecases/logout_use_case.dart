import 'package:habitly/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.signOut();
  }
}
