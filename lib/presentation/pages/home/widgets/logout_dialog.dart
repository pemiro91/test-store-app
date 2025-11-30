import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text("Cerrando sesión...",
                style: GoogleFonts.roboto(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}