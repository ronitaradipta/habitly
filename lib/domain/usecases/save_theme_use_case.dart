import 'package:habitly/domain/repositories/theme_repository.dart';

class SaveThemeUseCase {
  final ThemeRepository _themeRepository;

  SaveThemeUseCase(this._themeRepository);

  Future<void> call(String themeModeName) async {
    await _themeRepository.saveTheme(themeModeName);
  }
}
