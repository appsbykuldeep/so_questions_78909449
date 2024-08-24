import 'dart:math';

import 'package:done/components/my_button.dart';
import 'package:done/components/my_password_textfield.dart';
import 'package:done/components/my_textfield.dart';
import 'package:done/utilities/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePage;
  const LoginPage({
    super.key,
    required this.togglePage,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool checkboxValue = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 25.0,
                      left: 25.0,
                      right: 25.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 25.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Texte "Connextion"
                        Text(
                          "Connexion",
                          style: GoogleFonts.exo2(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),

                        const Gap(25),

                        // Textfield email
                        MyTextfield(
                          width: double.infinity,
                          height: 50,
                          controller: emailController,
                          hintText: "Adresse e-mail",
                          hintTextColor: Colors.white,
                          textColor: Colors.white,
                          borderColor: Colors.white,
                          isOneLine: true,
                        ),

                        const Gap(10),

                        // Textfield password
                        MyPasswordTextfield(
                          width: double.infinity,
                          height: 50,
                          controller: passwordController,
                          hintText: "Mot de passe",
                          hintTextColor: Colors.white,
                          borderColor: Colors.white,
                          textColor: Colors.white,
                          visibilityColor: Colors.white,
                        ),

                        const Gap(25),

                        // Bouton "Se connecter"
                        MyButton(
                          color: Colors.white,
                          text: "Se connecter",
                          width: double.infinity,
                          height: 50,
                          textColor: Colors.black,
                          onTap: () {
                            AuthService().signIn(context, emailController.text.trim(),
                                passwordController.text.trim());
                          },
                        ),

                        const Gap(10),

                        // Aucun compte existant ? Créer un compte
                        Row(
                          children: [
                            const Text(
                              "Aucun compte existant ? ",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.togglePage,
                              child: const Text(
                                "Créer un compte",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
