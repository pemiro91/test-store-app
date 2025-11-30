import 'package:flutter_bloc/flutter_bloc.dart';
part 'login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

  void emailChanged(String value) {
    String? error;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (value.isEmpty) {
      error = 'El correo no puede estar vacío';
    } else if (!emailRegex.hasMatch(value)) {
      error = 'Correo inválido';
    }

    emit(state.copyWith(
      email: value,
      emailError: error,
      clearEmailError: error == null,
    ));
  }

  void passwordChanged(String value) {
    String? error;

    if (value.isEmpty) {
      error = 'La contraseña no puede estar vacía';
    } else if (value.length < 8) {
      error = 'La contraseña debe tener al menos 8 caracteres';
    }

    emit(state.copyWith(
      password: value,
      passwordError: error,
      clearPasswordError: error == null,
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void clearErrors() {
    emit(state.copyWith(emailError: null, passwordError: null));
  }

  void validateAll(String email, String password) {
    emailChanged(email);
    passwordChanged(password);
  }
}