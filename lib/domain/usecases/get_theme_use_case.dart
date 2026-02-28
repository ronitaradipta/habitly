import 'package:habitly/domain/repositories/theme_repository.dart';

class GetThemeUseCase {
  final ThemeRepository _themeRepository;

  GetThemeUseCase(this._themeRepository);

  Future<String> call() async {
    return await _themeRepository.getTheme();
  }
}
