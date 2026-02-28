import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/domain/repositories/user_repository.dart';

class MarkOnboardingCompleteUseCase {
  final UserRepository _userRepository;

  MarkOnboardingCompleteUseCase(this._userRepository);

  Future<User> call(User currentUser) async {
    final updatedUser = currentUser.copyWith(hasCompletedOnboarding: true);

    await _userRepository.saveUser(updatedUser);

    return updatedUser;
  }
}
