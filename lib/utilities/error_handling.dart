import "package:another_flushbar/flushbar.dart";

class ErrorHandling {
  final fillUsername = Flushbar(
    message: "Vous devez fournir un nom d'utilisateur.",
    duration: const Duration(seconds: 3),
  );
  final fillEmail = Flushbar(
    message: "Veuillez fournir une adresse e-mail.",
    duration: const Duration(seconds: 3),
  );
  final fillPasswordSignUp = Flushbar(
    message: "Veuillez fournir un mot de passe (6 caractères minimum).",
    duration: const Duration(seconds: 3),
  );
  final fillPassword = Flushbar(
    message: "Veuillez fournir votre mot de passe.",
    duration: const Duration(seconds: 3),
  );
  final fillConfirmPassword = Flushbar(
    message: "Vous devez confirmer votre mot de passe.",
    duration: const Duration(seconds: 3),
  );
  final passwordConfirmationFailed = Flushbar(
    message: "La confirmation de votre mot de passe a échoué.",
    duration: const Duration(seconds: 3),
  );
  final fillTaskTitle = Flushbar(
    message: "Vous devez fournir un titre à la tâche.",
    duration: const Duration(seconds: 3),
  );
  final passwordTooShort = Flushbar(
    message: "Le mot de passe doit être d'au moins 6 caractères.",
    duration: const Duration(seconds: 3),
  );
  final unknownError = Flushbar(
    message: "Une erreur inconnue est survenue.",
    duration: const Duration(seconds: 3),
  );
  final taskDeletionFailed = Flushbar(
    message: "Erreur lors de la suppression de la tâche.",
    duration: const Duration(seconds: 3),
  );
}
