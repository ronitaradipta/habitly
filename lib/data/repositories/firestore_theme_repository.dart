import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitly/data/datasources/theme_datasource.dart';
import 'package:habitly/domain/repositories/theme_repository.dart';

class FirestoreThemeRepository implements ThemeRepository {
  final ThemeDatasource _datasource;
  final FirebaseAuth _auth;

  FirestoreThemeRepository({
    required ThemeDatasource datasource,
    FirebaseAuth? auth,
  }) : _datasource = datasource,
       _auth = auth ?? FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

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
