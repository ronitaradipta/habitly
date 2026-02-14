import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/utils/validators.dart';

class RegisterFormState {
  final String fullName;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;
  final String selectedGender;

  const RegisterFormState({
    this.fullName = '',
    this.email = '',
    this.mobile = '',
    this.password = '',
    this.confirmPassword = '',
    this.selectedGender = 'Female',
  });

  bool get isValid {
    return fullName.isNotEmpty &&
        Validators.isValidEmail(email) &&
        Validators.isValidMobile(mobile) &&
        Validators.isValidPassword(password) &&
        confirmPassword.isNotEmpty &&
        confirmPassword == password;
  }

  String? get fullNameError =>
      Validators.validateRequired(fullName, 'Full name');
  String? get emailError => Validators.validateEmail(email);
  String? get mobileError => Validators.validateMobile(mobile);
  String? get passwordError => Validators.validatePassword(password);
  String? get confirmPasswordError =>
      Validators.validateConfirmPassword(confirmPassword, password);

  RegisterFormState copyWith({
    String? fullName,
    String? email,
    String? mobile,
    String? password,
    String? confirmPassword,
    String? selectedGender,
  }) {
    return RegisterFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }
}

class RegisterFormNotifier extends Notifier<RegisterFormState> {
  @override
  RegisterFormState build() => const RegisterFormState();

  void updateFullName(String fullName) {
    state = state.copyWith(fullName: fullName.trim());
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email.trim());
  }

  void updateMobile(String mobile) {
    state = state.copyWith(mobile: mobile.trim());
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  void updateGender(String gender) {
    state = state.copyWith(selectedGender: gender);
  }

  void reset() {
    state = const RegisterFormState();
  }
}

final registerFormProvider =
    NotifierProvider<RegisterFormNotifier, RegisterFormState>(
      RegisterFormNotifier.new,
    );
