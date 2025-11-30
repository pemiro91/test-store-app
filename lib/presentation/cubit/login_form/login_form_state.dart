part of 'login_form_cubit.dart';
class LoginFormState {
  final String email;
  final String? emailError;
  final String password;
  final String? passwordError;
  final bool showPassword;

  const LoginFormState({
    this.email = '',
    this.emailError,
    this.password = '',
    this.passwordError,
    this.showPassword = false,
  });

  LoginFormState copyWith({
    String? email,
    String? emailError,
    bool clearEmailError = false,
    String? password,
    String? passwordError,
    bool clearPasswordError = false,
    bool? showPassword,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      password: password ?? this.password,
      passwordError:
      clearPasswordError ? null : (passwordError ?? this.passwordError),
      showPassword: showPassword ?? this.showPassword,
    );
  }

  bool get isValid => emailError == null && passwordError == null;
}