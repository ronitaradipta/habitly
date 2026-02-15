abstract class ThemeRepository {
  Future<String> getTheme();
  Future<void> saveTheme(String themeModeName);
}
