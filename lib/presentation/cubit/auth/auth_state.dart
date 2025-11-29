part of 'auth_cubit.dart';

enum AuthStatus { idle, loading, success, error, needsAuthorization }

class AuthState {
  final AuthStatus status;
  final String? error;
  final String? emailError;
  final String? passwordError;
  final bool? isLoggedIn;

  const AuthState({
    this.status = AuthStatus.idle,
    this.error,
    this.emailError,
    this.passwordError,
    this.isLoggedIn,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? error,
    String? emailError,
    String? passwordError,
    bool? isLoggedIn,
  }) {
    return AuthState(
        status: status ?? this.status,
        error: error,
        emailError: emailError,
        passwordError: passwordError,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn
    );
  }

  bool get isValid => emailError == null && passwordError == null;
  bool get isValidReset => emailError == null;
}
