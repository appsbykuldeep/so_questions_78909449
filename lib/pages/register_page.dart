import 'dart:math';
import 'package:done/components/my_button.dart';
import 'package:done/components/my_password_textfield.dart';
import 'package:done/components/my_textfield.dart';
import 'package:done/utilities/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePage;
  const RegisterPage({
    super.key,
    required this.togglePage,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                          "Inscription",
                          style: GoogleFonts.exo2(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),

                        const Gap(25),

                        // Textfield nom d'utilisateur
                        MyTextfield(
                          width: double.infinity,
                          height: 50,
                          controller: usernameController,
                          hintText: "Nom d'utilisateur",
                          isOneLine: true,
                          hintTextColor: Colors.white,
                          borderColor: Colors.white,
                          textColor: Colors.white,
                        ),

                        const Gap(10),

                        // Textfield email
                        MyTextfield(
                          width: double.infinity,
                          height: 50,
                          controller: emailController,
                          hintText: "Adresse e-mail",
                          isOneLine: true,
                          hintTextColor: Colors.white,
                          borderColor: Colors.white,
                          textColor: Colors.white,
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

                        const Gap(10),

                        // Textfield confirmer son mot de passe
                        MyPasswordTextfield(
                          width: double.infinity,
                          height: 50,
                          controller: confirmPasswordController,
                          hintText: "Confirmez votre mot de passe",
                          hintTextColor: Colors.white,
                          borderColor: Colors.white,
                          textColor: Colors.white,
                          visibilityColor: Colors.white,
                        ),

                        const Gap(25),

                        // Bouton "Se connecter"
                        MyButton(
                          color: Colors.white,
                          text: "S'inscrire",
                          width: double.infinity,
                          height: 50,
                          textColor: Colors.black,
                          borderColor: Colors.white,
                          onTap: () {
                            AuthService().signUp(
                              context,
                              usernameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              confirmPasswordController.text.trim(),
                            );
                          },
                        ),

                        const Gap(10),

                        // Aucun compte existant ? Créer un compte
                        Row(
                          children: [
                            const Text(
                              "Déjà un compte ? ",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.togglePage,
                              child: const Text(
                                "Se connecter",
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
