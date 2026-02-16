import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/repositories/auth_repository.dart';
import 'package:habitly/domain/repositories/user_repository.dart';

class GetCurrentUserUseCase {
  final UserRepository _repository;
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._repository, this._authRepository);

  Future<User?> call() async {
    final uid = _authRepository.currentUserId;
    if (uid == null) return null;

    return _repository.getCurrentUser();
  }
}
