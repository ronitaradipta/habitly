import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/utils/validators.dart';

class LoginFormState {
  final String email;

  const LoginFormState({this.email = ''});

  bool get isValid => Validators.isValidEmail(email);
  String? get emailError => Validators.validateEmail(email);

  LoginFormState copyWith({String? email}) {
    return LoginFormState(email: email ?? this.email);
  }
}

class LoginFormNotifier extends Notifier<LoginFormState> {
  @override
  LoginFormState build() => const LoginFormState();

  void updateEmail(String email) {
    state = state.copyWith(email: email.trim());
  }

  void reset() {
    state = const LoginFormState();
  }
}

final loginFormProvider = NotifierProvider<LoginFormNotifier, LoginFormState>(
  LoginFormNotifier.new,
);
