import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:store/core/utils/contants.dart';
import 'package:store/data/repositories/auth_repository_impl.dart';

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
    if (!ok) emit(state.copyWith(status: AuthStatus.error, error: "Google login failed"));
  }

  Future<void> authorizeScopes() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final ok = await authRepository.requestScopes();
    if (!ok) emit(state.copyWith(status: AuthStatus.error, error: "Authorization failed"));

  }

  Future<void> signInWithFacebook() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final ok = await authRepository.signInWithFacebook();
    if (ok) {
      state.copyWith(
        status: AuthStatus.success,
        isLoggedIn: true,
      );
    } else {
      emit(state.copyWith(status: AuthStatus.error, error: 'Facebook sign in failed'));
    }
  }

  Future<void> signOut(BuildContext context) async {
    await authRepository.signOut();
    emit(state.copyWith(status: AuthStatus.idle));
    if(!context.mounted) return;
    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    context.goNamed(login);
  }
}