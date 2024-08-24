import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

errorPage() {
  ErrorWidget.builder = (FlutterErrorDetails error) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Image
            Image.asset("assets/erreur.jpg"),

            // Texte
            Text(
              "Oops ...\n\n"
              "Vous ne devriez pas arriver sur cette page.\n"
              "Essayez de relancer l'application.",
              style: GoogleFonts.exo2(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  };
}
