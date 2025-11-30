import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:store/core/utils/contants.dart';
import 'package:store/data/repositories/auth_repository_impl.dart';
import 'package:store/presentation/pages/home/widgets/logout_dialog.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepositoryImpl authRepository;
  AuthCubit({required this.authRepository}) : super(const AuthState()){
    authRepository.status.listen((status) {
      switch (status) {
        case AuthRepositoryStatus.authorized:
          emit(state.copyWith(status: AuthStatus.success));
          break;
        case AuthRepositoryStatus.needsAuthorization:
          emit(state.copyWith(status: AuthStatus.needsAuthorization));
          break;
        case AuthRepositoryStatus.signedOut:
          emit(state.copyWith(status: AuthStatus.idle));
          break;
        default:
          break;
      }
    });
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final ok = await authRepository.signInWithGoogle();
    if (ok) {

      await Future.delayed(const Duration(milliseconds: 500));

      emit(state.copyWith(
        status: AuthStatus.success,
        provider: AuthProvider.google,
        email: authRepository.currentUserEmail,
        isLoggedIn: true,
      ));
    } else {
      emit(state.copyWith(status: AuthStatus.error, error: "Google login failed"));
    }
  }

  Future<void> authorizeScopes() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final ok = await authRepository.requestScopes();
    if (!ok) emit(state.copyWith(status: AuthStatus.error, error: "Authorization failed"));

  }

  Future<bool> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {


        final userData = await FacebookAuth.instance.getUserData();
        // _facebookUserEmail = userData['email'] as String?;

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    emit(state.copyWith(status: AuthStatus.loading, isLoggingOut: true));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LogoutDialog(),
    );

    await Future.delayed(const Duration(milliseconds: 2000));

    await authRepository.signOut();
  }

  void resetLogoutFlag() {
    emit(state.copyWith(isLoggingOut: false));
  }

  void signInWithEmail(String email) {
    emit(state.copyWith(
      status: AuthStatus.success,
      provider: AuthProvider.none, // Normal
      email: email,
      isLoggedIn: true,
    ));
  }
}