part of 'auth_cubit.dart';

enum AuthStatus { idle, loading, success, error, needsAuthorization }

enum AuthProvider { none, google, facebook }

class AuthState {
  final AuthStatus status;
  final AuthProvider provider;
  final String? email;
  final String? error;
  final String? emailError;
  final String? passwordError;
  final bool? isLoggedIn;
  final bool isLoggingOut;

  const AuthState({
    this.status = AuthStatus.idle,
    this.provider = AuthProvider.none,
    this.email,
    this.error,
    this.emailError,
    this.passwordError,
    this.isLoggedIn,
    this.isLoggingOut = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthProvider? provider,
    String? error,
    String? email,
    String? emailError,
    String? passwordError,
    bool? isLoggedIn,
    bool? isLoggingOut,
  }) {
    return AuthState(
      status: status ?? this.status,
      provider: provider ?? this.provider,
      error: error,
      email: email,
      emailError: emailError,
      passwordError: passwordError,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  bool get isValid => emailError == null && passwordError == null;

  bool get isValidReset => emailError == null;
}
