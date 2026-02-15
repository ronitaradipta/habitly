import 'package:habitly/domain/repositories/theme_repository.dart';

class GetThemeUseCase {
  final ThemeRepository _repository;

  GetThemeUseCase(this._repository);

  Future<String> call() {
    return _repository.getTheme();
  }
}
