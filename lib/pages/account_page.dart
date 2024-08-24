import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done/components/my_button.dart';
import 'package:done/utilities/auth_service.dart';
import 'package:done/utilities/my_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:segmented_button_slide/segmented_button_slide.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: Text(
          "Mon compte",
          style: GoogleFonts.exo2(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      body: Consumer<MyProvider>(
        builder: (context, provider, _) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Nom d'utilisateur
                  Column(
                    children: [
                      Text(
                        "Nom d'utilisateur actuel :",
                        style: GoogleFonts.exo2(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        provider.user?["username"] ?? "",
                        style: GoogleFonts.exo2(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(25),
                      MyButton(
                        color: Colors.transparent,
                        text: "Changer de nom d'utilisateur",
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: 50,
                        textColor: Theme.of(context).colorScheme.primary,
                        borderColor: Theme.of(context).colorScheme.primary,
                        onTap: () {
                          AuthService().changeUsername(context);
                        },
                      ),
                    ],
                  ),

                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    height: 50,
                  ),

                  // Nombre de tâche
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: "Vous avez actuellement ",
                      style: GoogleFonts.exo2(
                        fontSize: 20,
                      ),
                      children: [
                        TextSpan(
                          text: provider.tasks?.length.toString() ?? "0",
                          style: GoogleFonts.exo2(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: (provider.tasks?.length ?? 0) < 2
                              ? " tâche."
                              : " tâches.",
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    height: 50,
                  ),

                  // Thèmes
                  SegmentedButtonSlide(
                    entries: const [
                      SegmentedButtonSlideEntry(label: "Clair"),
                      SegmentedButtonSlideEntry(label: "Sombre"),
                    ],
                    selectedEntry:
                        Provider.of<MyProvider>(context, listen: false)
                                    .user!["theme"] ==
                                "light"
                            ? 0
                            : 1,
                    onChange: (int value) {
                      // Mettre à jour l'inteface
                      Provider.of<MyProvider>(context, listen: false)
                          .setTheme(value == 0 ? "light" : "dark");
                      // Mettre à jour la base de données
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(Provider.of<MyProvider>(context, listen: false)
                              .user!["ID"])
                          .update(
                        {
                          "theme": value == 0 ? "light" : "dark",
                        },
                      );
                    },
                    colors: const SegmentedButtonSlideColors(
                      barColor: Colors.white,
                      backgroundSelectedColor: Colors.black,
                    ),
                    unselectedTextStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    height: 50,
                  ),

                  // Se déconnecter
                  MyButton(
                    text: "Se déconnecter",
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 50,
                    color: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).colorScheme.secondary,
                    onTap: () async {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        title: "Déconnexion",
                        text: "Êtes-vous sûr de vouloir vous déconnecter ?",
                        cancelBtnText: "Non",
                        onCancelBtnTap: () {
                          // Quitter le popup
                          Navigator.pop(context);
                        },
                        confirmBtnColor: Colors.black,
                        confirmBtnText: "Oui",
                        onConfirmBtnTap: () {
                          // Quitter le popup
                          Navigator.pop(context);

                          // Déconnecter l'utilisateur
                          AuthService().signOut(context);

                          // Quitter la page de compte
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
