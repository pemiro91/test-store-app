import 'package:flutter_bloc/flutter_bloc.dart';
part 'login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

  void emailChanged(String value) {
    String? error;
    if (value.isEmpty) {
      error = 'El correo no puede estar vacío';
    } else if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      error = 'Correo inválido';
    }
    emit(state.copyWith(email: value, emailError: error));
  }

  void passwordChanged(String value) {
    String? error;
    if (value.isEmpty) {
      error = 'La contraseña no puede estar vacía';
    } else if (value.length < 8) {
      error = 'La contraseña debe tener al menos 8 caracteres';
    }
    emit(state.copyWith(password: value, passwordError: error));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void clearErrors() {
    emit(state.copyWith(emailError: null, passwordError: null));
  }
}