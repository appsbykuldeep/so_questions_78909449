import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done/components/my_textfield.dart';
import 'package:done/utilities/error_handling.dart';
import 'package:done/utilities/my_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';

class AuthService {
  // --- Créer un compte ---
  void signUp(context, String username, String email, String password,
      String confirmPassword) {
    // Vérifier les entrées utilisateurs
    if (username == "") {
      ErrorHandling().fillUsername.show(context);
    } else if (email == "") {
      ErrorHandling().fillEmail.show(context);
    } else if (password == "") {
      ErrorHandling().fillPasswordSignUp.show(context);
    } else if (confirmPassword == "") {
      ErrorHandling().fillConfirmPassword.show(context);
    } else if (password != confirmPassword) {
      ErrorHandling().passwordConfirmationFailed.show(context);
    } else if (password.length < 6) {
      ErrorHandling().passwordTooShort.show(context);
    } else {
      try {
        // Créer l'utilisateur
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then(
          (userCredential) {
            // Récupérer l'uid de l'utilisateur
            String userID = userCredential.user!.uid;

            // Créer le doc de l'utilisateur dans la base de données
            FirebaseFirestore.instance.collection("Users").doc(userID).set(
              {
                "name": username,
                "firstLaunch": true,
                "theme": "light",
              },
            );
          },
        );
      } catch (e) {
        ErrorHandling().unknownError.show(context);
      }
    }
  }

  // --- Se connecter ---
  void signIn(context, email, password) {
    // Vérifier les entrées utilisateur
    if (email == "") {
      ErrorHandling().fillEmail.show(context);
    } else if (password == "") {
      ErrorHandling().fillPassword.show(context);
    } else {
      try {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } catch (e) {
        // Afficher une Flushbar lors d'une erreur
        ErrorHandling().unknownError.show(context);
      }
    }
  }

  // --- Se déconnecter ---
  void signOut(context) {
    try {
      // Déconnecter l'utilsateur
      FirebaseAuth.instance.signOut();
    } catch (e) {
      // Afficher une Flushbar lors d'une erreur
      Flushbar(
        message: e.toString(),
        duration: const Duration(seconds: 5),
      );
    }
  }

  // --- Changer de nom d'utilisateur ---
  void changeUsername(context) {
    showDialog(
      context: context,
      builder: (context) {
        return const ChangeUsernameUI();
      },
    );
  }

  // --- Supprimer son compte ---
}

class ChangeUsernameUI extends StatefulWidget {
  const ChangeUsernameUI({super.key});

  @override
  State<ChangeUsernameUI> createState() => _ChangeUsernameUIState();
}

class _ChangeUsernameUIState extends State<ChangeUsernameUI> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text =
        Provider.of<MyProvider>(context, listen: false).user!["username"];
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Textfield pour le nouveau nom d'utilisateur
              MyTextfield(
                width: double.maxFinite,
                height: 50,
                controller: _controller,
                hintText: "Nouveau nom d'utilisateur",
                isOneLine: true,
                borderColor: Theme.of(context).colorScheme.primary,
              ),

              // Bouton pour appliquer
              MyButton(
                text: "Appliquer",
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
                color: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.secondary,
                onTap: () {
                  // Vérifier les entrées utilisateur
                  if (_controller.text.trim() == "") {
                    ErrorHandling().fillUsername.show(context);
                  } else {
                    // Mettre à jour l'interface
                    Provider.of<MyProvider>(context, listen: false)
                        .setUsername(_controller.text.trim());

                    // Mettre à jour la base de données
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update(
                      {
                        "name": _controller.text.trim(),
                      },
                    );
                    Navigator.pop(context);
                  }
                },
              ),

              // Bouton Annuler
              MyButton(
                text: "Annuler",
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
                color: Colors.transparent,
                textColor: Theme.of(context).colorScheme.primary,
                borderColor: Theme.of(context).colorScheme.primary,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
