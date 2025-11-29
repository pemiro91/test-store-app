import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store/core/utils/contants.dart';
import 'package:store/presentation/cubit/auth/auth_cubit.dart';
import 'package:store/presentation/cubit/login_form/login_form_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return BlocProvider(
      create: (_) => LoginFormCubit(),
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.success) {
              context.goNamed(home);
            } else if (state.status == AuthStatus.error && state.error != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error!, style: GoogleFonts.roboto(fontSize: 16))));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Icon(Icons.store, color: Colors.blue, size: 80),
                    const SizedBox(height: 40),
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            BlocBuilder<LoginFormCubit, LoginFormState>(
                              builder: (context, formState) {
                                return TextField(
                                  onChanged: context
                                      .read<LoginFormCubit>()
                                      .emailChanged,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.email),
                                    labelText: 'Correo electrónico',
                                    errorText: formState.emailError,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<LoginFormCubit, LoginFormState>(
                              builder: (context, formState) {
                                return TextField(
                                  onChanged: context
                                      .read<LoginFormCubit>()
                                      .passwordChanged,
                                  obscureText: !formState.showPassword,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock),
                                    labelText: 'Contraseña',
                                    errorText: formState.passwordError,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    suffixIcon: IconButton(
                                      icon: Icon(formState.showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () => context
                                          .read<LoginFormCubit>()
                                          .togglePasswordVisibility(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text('Olvidé mi contraseña', style: GoogleFonts.roboto(fontSize: 16)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  final formState =
                                      context.read<LoginFormCubit>().state;
                                  if (formState.isValid) {
                                    context.goNamed(home);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: state.status == AuthStatus.loading
                                    ? const CircularProgressIndicator(
                                    color: Colors.white)
                                    : Text('Iniciar sesión'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Image.asset(
                              'assets/images/google_logo.png',
                              height: 20,
                            ),
                            label: Text('Iniciar con Google', style: GoogleFonts.roboto(fontSize: 16)),
                            onPressed: () => authCubit.signInWithGoogle(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: Colors.grey)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Image.asset(
                              'assets/images/facebook_logo.png',
                              height: 20,
                            ),
                            label: Text('Iniciar con Facebook', style: GoogleFonts.roboto(fontSize: 16)),
                            onPressed: () => authCubit.signInWithFacebook(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1877F2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
