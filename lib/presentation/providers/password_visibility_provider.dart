import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordVisibilityNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => {};

  bool isVisible(String fieldKey) => state[fieldKey] ?? false;

  void toggle(String fieldKey) {
    state = {...state, fieldKey: !(state[fieldKey] ?? false)};
  }
}

final passwordVisibilityProvider =
    NotifierProvider.autoDispose<PasswordVisibilityNotifier, Map<String, bool>>(
  PasswordVisibilityNotifier.new,
);
