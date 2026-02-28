import 'package:habitly/data/datasources/auth_datasource.dart';
import 'package:habitly/data/datasources/theme_datasource.dart';
import 'package:habitly/domain/repositories/theme_repository.dart';

class FirestoreThemeRepository implements ThemeRepository {
  final ThemeDatasource _datasource;
  final AuthDatasource _authDatasource;

  FirestoreThemeRepository({
    required ThemeDatasource datasource,
    required AuthDatasource authDatasource,
  }) : _datasource = datasource,
       _authDatasource = authDatasource;

  String? get _uid => _authDatasource.currentUserId;

  @override
  Future<String> getTheme() async {
    final uid = _uid;
    if (uid == null) return 'system';

    return await _datasource.getTheme(uid);
  }

  @override
  Future<void> saveTheme(String themeModeName) async {
    final uid = _uid;
    if (uid == null) return;

    await _datasource.saveTheme(uid, themeModeName);
  }
}
