import 'package:habitly/data/datasources/local_data_source.dart';
import 'package:habitly/domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final LocalDataSource _localDataSource;

  ThemeRepositoryImpl(this._localDataSource);

  @override
  Future<String> getTheme() {
    return _localDataSource.getTheme();
  }

  @override
  Future<void> saveTheme(String themeModeName) {
    return _localDataSource.saveTheme(themeModeName);
  }
}
