import 'package:habitly/domain/repositories/theme_repository.dart';

class SaveThemeUseCase {
  final ThemeRepository _repository;

  SaveThemeUseCase(this._repository);

  Future<void> call(String themeModeName) {
    return _repository.saveTheme(themeModeName);
  }
}
