import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done/firebase_options.dart';
import 'package:done/pages/home_page.dart';
import 'package:done/pages/introduction_page.dart';
import 'package:done/pages/loading_screen.dart';
import 'package:done/pages/login_or_register_page.dart';
import 'package:done/pages/splash_screen.dart';
import 'package:done/themes/dark_theme.dart';
import 'package:done/themes/light_theme.dart';
import 'package:done/utilities/error_page.dart';
import 'package:done/utilities/my_provider.dart';
import 'package:done/utilities/provider_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialisation de Flutter*
  await Firebase.initializeApp(
      options:
          DefaultFirebaseOptions.currentPlatform); // Initialisation de Firebase
  errorPage(); // Initialiser la page d'erreur
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> _userAuthStream;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _tasksStream;

  @override
  void initState() {
    _userAuthStream = FirebaseAuth.instance.authStateChanges().listen(
      (User? user) async {
        bool isUserLoggedIn = await ProviderService().updateUser(context);
        if (isUserLoggedIn) {
          await ProviderService().loadTasks(context); // Charger les tâches
          ProviderService().updateTaskDonePercentage(
              context); // Charger le percent indicator
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _userAuthStream.cancel();
    _tasksStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, provider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: provider.user?["theme"] == "light" ? lightTheme : darkTheme,
          home: provider.user == null
              ? const SplashScreen() // SplashScreen / Chargement de l'utilisateur
              : provider.user!.isNotEmpty && provider.tasks == null
                  ? const LoadingScreen() // Chargement ...
                  : provider.user!.isNotEmpty
                      ? provider.user!["isFirstLaunch"] == true
                          ? const IntroductionPage() // Page d'introduction
                          : const HomePage() // Page d'accueil
                      : const LoginOrRegisterPage(), // Pages de connexion / inscription
        );
      },
    );
  }
}
