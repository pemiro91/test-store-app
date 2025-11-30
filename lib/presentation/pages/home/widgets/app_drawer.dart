import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store/presentation/cubit/auth/auth_cubit.dart';

import 'empty_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    String userEmail = authState.email ?? "Invitado";
    String accessType;
    switch (authState.provider) {
      case AuthProvider.google:
        accessType = "Google";
        break;
      case AuthProvider.facebook:
        accessType = "Facebook";
        break;
      default:
        accessType = "Básico";
    }
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.store, color: Colors.white, size: 48),
                const SizedBox(height: 16),
                Text(userEmail,
                    style: GoogleFonts.roboto(
                        fontSize: 16, color: Colors.white)),
                const SizedBox(height: 4),
                Text("Acceso: $accessType",
                    style: GoogleFonts.roboto(
                        fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Perfil', style: GoogleFonts.roboto(fontSize: 16)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmptyScreen(title: 'Perfil'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text('Mis productos', style: GoogleFonts.roboto(fontSize: 16)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmptyScreen(title: 'Mis productos'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text('Configuraciones', style: GoogleFonts.roboto(fontSize: 16)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmptyScreen(title: 'Configuraciones'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('Cerrar sesión', style: GoogleFonts.roboto(fontSize: 16)),
            onTap: () {
              context.read<AuthCubit>().signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
