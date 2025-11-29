import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyScreen extends StatelessWidget {
  final String title;
  const EmptyScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, style: GoogleFonts.roboto(fontSize: 16))),
      body: Center(child: Text(title, style: GoogleFonts.roboto(fontSize: 16))),
    );
  }
}