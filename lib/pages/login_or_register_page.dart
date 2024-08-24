import 'dart:math';

import 'package:done/components/my_button.dart';
import 'package:done/pages/login_page.dart';
import 'package:done/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  int pageIndex = 1;

  void togglePage() {
    setState(() {
      pageIndex == 2 ? pageIndex = 3 : pageIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pageIndex == 1) {
      return Scaffold(
        body: Stack(
          children: [
            // Background
            Transform.scale(
              scale: 5.0,
              child: Transform.rotate(
                angle: pi / 2,
                child: Image.asset("assets/login_pages_background.jpg"),
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Logo Bubble
                    const Icon(
                      Icons.sticky_note_2,
                      color: Colors.white,
                      size: 150,
                    ),
                    // Textes de bienvenue
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(18.0)),
                      padding: const EdgeInsets.all(15.0),
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: "Bienvenue dans ",
                          style: GoogleFonts.exo2(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                          children: [
                            TextSpan(
                              text: "Notes",
                              style: GoogleFonts.kanit(
                                fontSize: 35,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "\n\nCréez un compte ou connectez vous pour commencer\n"
                                  "une belle et heureuse journée.",
                              style: GoogleFonts.exo2(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bouton pour se connecter
                    Column(
                      children: [
                        MyButton(
                          color: Colors.white,
                          text: "Se connecter",
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          textColor: Colors.black,
                          onTap: () {
                            setState(() {
                              pageIndex = 2;
                            });
                          },
                        ),
                        const Gap(15),
                        // Bouton pour s'inscrire
                        MyButton(
                          color: Colors.transparent,
                          text: "S'inscrire",
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          textColor: Colors.white,
                          borderColor: Colors.white,
                          onTap: () {
                            setState(() {
                              pageIndex = 3;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } else if (pageIndex == 2) {
      return LoginPage(togglePage: togglePage);
    } else {
      return RegisterPage(togglePage: togglePage);
    }
  }
}
