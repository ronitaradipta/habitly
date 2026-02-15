class HiveConstants {
  HiveConstants._();

  static const String habitBox = 'habitBox';
  static const String themeBox = 'themeBox';
  static const String authBox = 'authBox';
  static const String registeredUsersBox = 'registeredUsersBox';

  static const String themeKey = 'themeMode';
  static const String userKey = 'user';

  static String habitListKeyForUser(String email) => 'habits_$email';

  static String registeredUserKey(String email) => 'registered_$email';
}
