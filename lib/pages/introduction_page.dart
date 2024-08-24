import 'dart:async';

import 'package:done/components/my_intro_message.dart';
import 'package:done/components/my_intro_textfield.dart';
import 'package:done/components/my_message.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  PageController pageController = PageController();
  bool checkAllVisibility = false;

  @override
  void initState() {
    Timer(
      const Duration(milliseconds: 2500),
      () {
        setState(() {
          checkAllVisibility = true;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bubble",
          style: GoogleFonts.pacifico(fontSize: 30),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE9A785),
                Color(0xFF9AABA0),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Texte "Aujourd'hui"
                const Text(
                  "Aujourd'hui",
                  style: TextStyle(
                    color: Color.fromARGB(255, 170, 167, 182),
                  ),
                ),

                const Gap(10),

                // Premier message
                const MyIntroMessage(
                  message:
                      "Salut, tu connais une bonne application de gestion de tâches ?",
                  delay: 0,
                ),
                const Gap(5),
                Visibility(
                  visible: checkAllVisibility,
                  child: Row(
                    children: [
                      Gap(MediaQuery.of(context).size.width * 0.1 + 25),
                      Icon(
                        Icons.done_all,
                        color: Colors.grey[500],
                      ),
                      const Gap(5),
                      Text(
                        "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, "0")}",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),

                const Gap(25),

                // Deuxième message
                const Align(
                  alignment: Alignment.centerRight,
                  child: MyMessage(
                    message:
                        "Ouais, l'application s'appelle Bubble ! Elle est très simple mais aussi très esthetique.",
                    delay: 500,
                  ),
                ),
                const Gap(5),
                Visibility(
                  visible: checkAllVisibility,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.done_all,
                        color: Colors.grey[500],
                      ),
                      const Gap(5),
                      Text(
                        "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, "0")}",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      const Gap(25),
                    ],
                  ),
                ),

                const Gap(25),

                // 3eme message
                const MyIntroMessage(
                    message:
                        "Elle est gratuite ?\nLes tâches se sauvegardent ?",
                    delay: 1000),
                const Gap(5),
                Visibility(
                  visible: checkAllVisibility,
                  child: Row(
                    children: [
                      Gap(MediaQuery.of(context).size.width * 0.1 + 25),
                      Icon(
                        Icons.done_all,
                        color: Colors.grey[500],
                      ),
                      const Gap(5),
                      Text(
                        "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, "0")}",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),

                const Gap(25),

                // Dernier message
                const Align(
                  alignment: Alignment.centerRight,
                  child: MyMessage(
                      message:
                          "Bien sûr ! Elle est gratuite et toutes les tâches sont synchronisées grâce à ton compte.",
                      delay: 1500),
                ),
                const Gap(5),
                Visibility(
                  visible: checkAllVisibility,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.done_all,
                        color: Colors.grey[500],
                      ),
                      const Gap(5),
                      Text(
                        "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, "0")}",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      const Gap(25),
                    ],
                  ),
                ),

                const Gap(15),

                // Bouton "Commencer avec Bubble"
                const MyIntroTextfield(delay: 2000),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
