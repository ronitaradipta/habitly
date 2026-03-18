import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/utils/validators.dart';

class LoginFormState {
  final String email;
  final String password;

  const LoginFormState({this.email = '', this.password = ''});

  bool get isValid =>
      Validators.isValidEmail(email) && Validators.isValidPassword(password);
  String? get emailError => Validators.validateEmail(email);
  String? get passwordError => Validators.validatePassword(password);

  LoginFormState copyWith({String? email, String? password}) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class LoginFormNotifier extends Notifier<LoginFormState> {
  @override
  LoginFormState build() => const LoginFormState();

  void updateEmail(String email) {
    state = state.copyWith(email: email.trim());
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }
}

final loginFormProvider =
    NotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>(
      LoginFormNotifier.new,
    );
