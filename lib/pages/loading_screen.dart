import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Mise en cache des images
          Opacity(
            opacity: 0,
            child: Stack(
              children: [
                Image.asset("assets/courses.png"),
                Image.asset("assets/erreur.jpg"),
                Image.asset("assets/études.png"),
                Image.asset("assets/false.png"),
                Image.asset("assets/launcher_icon.png"),
                Image.asset("assets/loading.png"),
                Image.asset("assets/login_pages_background.jpg"),
                Image.asset("assets/ménage.png"),
                Image.asset("assets/no_task.png"),
                Image.asset("assets/null.png"),
                Image.asset("assets/rdv.png"),
                Image.asset("assets/sport.png"),
                Image.asset("assets/travail.png"),
                Image.asset("assets/true.png"),
              ],
            ),
          ),

          // Progress Indicator
          const Center(
            child: LoadingIndicator(
              indicatorType: Indicator.pacman,
              colors: [Colors.white],
              backgroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
