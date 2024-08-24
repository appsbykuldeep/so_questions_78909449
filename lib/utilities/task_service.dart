import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done/components/my_button.dart';
import 'package:done/components/my_textfield.dart';
import 'package:done/utilities/error_handling.dart';
import 'package:done/utilities/my_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import "package:provider/provider.dart";

class TaskService {
  // Créer une tâche
  void showAddTaskPopup(context) {
    // Affichage de la ModalBottomSheet
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const AddTaskPopup();
      },
    );
  }

  // Supprimer une tâche
  void deleteTask(context, int taskIndex) async {
    try {
      // Récupérer l'ID de la tâche
      final String taskID = Provider.of<MyProvider>(context, listen: false)
          .tasks![taskIndex]["ID"];

      // Supprimer la tâche du Provider
      Provider.of<MyProvider>(context, listen: false).deleteTask(
        context,
        taskID,
      );

      // Récupérer les informations nécessaires
      final String userID =
          Provider.of<MyProvider>(context, listen: false).user!["ID"];
      final QuerySnapshot imagesCollection = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userID)
          .collection("Tasks")
          .doc(taskID)
          .collection("Images")
          .get();

      // Si la tâche a des images
      if (imagesCollection.docs.isNotEmpty) {
        // Supprimer toutes les images associées à la tâche
        final Reference storageRef = FirebaseStorage.instance.ref();
        storageRef.child("$userID/$taskIndex").delete();
      }

      // Supprimer la tâche de la base de données
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userID)
          .collection("Tasks")
          .doc(taskID)
          .delete();

      // Informer l'utilisateur de la suppression de la tâche
      Flushbar(
        message: "La tâche a bien été supprimée",
        duration: const Duration(seconds: 2),
      ).show(context);
    } catch (e) {
      ErrorHandling().taskDeletionFailed.show(context);
    }
  }

  // Supprimer les tâches terminées
  void deleteDoneTasks(context) {
    try {
      final List<Map<String, dynamic>> taskDoneData =
          Provider.of<MyProvider>(context, listen: false).tasks!.where(
        (element) {
          return element["state"];
        },
      ).toList();

      for (int i = taskDoneData.length; i != 0; i--) {
        if (taskDoneData[i - 1]["images"].isNotEmpty) {
          for (int j = taskDoneData[i - 1]["images"].length; j != 0; j--) {
            FirebaseStorage.instance
                .refFromURL(taskDoneData[i - 1]["images"][j - 1])
                .delete();
          }
        }
        FirebaseFirestore.instance
            .collection("Users")
            .doc(Provider.of<MyProvider>(context, listen: false).user!["ID"])
            .collection("Tasks")
            .doc(taskDoneData[i - 1]["ID"])
            .delete();
      }
      List taskDoneID = taskDoneData.map((element) => element["ID"]).toList();

      for (int i = taskDoneID.length; i != 0; i--) {
        Provider.of<MyProvider>(context, listen: false).deleteTask(
          context,
          taskDoneID[i - 1],
        );
      }

      Flushbar(
        message: taskDoneData.length > 1
            ? "${taskDoneData.length} tâches supprimées"
            : "${taskDoneData.length} tâche supprimée",
        duration: const Duration(seconds: 2),
      ).show(context);
    } catch (e) {
      Flushbar(
        message: "Erreur lors de la suppression.",
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  // Modifier le titre d'une tâche
  void editTitle(context, int taskIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return ChangeTaskTitleUI(taskIndex: taskIndex);
      },
    );
  }

  // Modifier le thème d'une tâche
  void editTheme(context, int taskIndex, newTheme) {
    Provider.of<MyProvider>(context, listen: false).editTask(
      context,
      taskIndex,
      "theme",
      newTheme,
      false,
    );
    Provider.of<MyProvider>(context, listen: false).editTask(
      context,
      taskIndex,
      "themeColor",
      TaskService().fetchThemeColor(newTheme),
      false,
    );

    FirebaseFirestore.instance
        .collection("Users")
        .doc(Provider.of<MyProvider>(context, listen: false).user!["ID"])
        .collection("Tasks")
        .doc(Provider.of<MyProvider>(context, listen: false).tasks![taskIndex]
            ["ID"])
        .update(
      {
        "theme": newTheme,
      },
    );
  }

  // Modifier le thème d'une tâche
  void editPriority(context, int taskIndex, newPriority) {
    Provider.of<MyProvider>(context, listen: false).editTask(
      context,
      taskIndex,
      "priority",
      newPriority,
      false,
    );
    Provider.of<MyProvider>(context, listen: false).editTask(
      context,
      taskIndex,
      "priorityColor",
      TaskService().fetchPriorityColor(newPriority),
      false,
    );

    FirebaseFirestore.instance
        .collection("Users")
        .doc(Provider.of<MyProvider>(context, listen: false).user!["ID"])
        .collection("Tasks")
        .doc(Provider.of<MyProvider>(context, listen: false).tasks![taskIndex]
            ["ID"])
        .update(
      {
        "priority": newPriority,
      },
    );
  }

  // Modifier l'état d'une tâche
  void editState(context, int taskIndex, bool newState) {
    Provider.of<MyProvider>(context, listen: false).editTask(
      context,
      taskIndex,
      "state",
      newState,
      false,
    );

    FirebaseFirestore.instance
        .collection("Users")
        .doc(Provider.of<MyProvider>(context, listen: false).user!["ID"])
        .collection("Tasks")
        .doc(Provider.of<MyProvider>(context, listen: false).tasks![taskIndex]
            ["ID"])
        .update(
      {
        "state": newState,
      },
    );
  }

  // Modifier la description
  void editDescription(context, int taskIndex, String newDescription) {
    Provider.of<MyProvider>(context, listen: false).editTask(
      context,
      taskIndex,
      "description",
      newDescription,
      false,
    );

    FirebaseFirestore.instance
        .collection("Users")
        .doc(Provider.of<MyProvider>(context, listen: false).user!["ID"])
        .collection("Tasks")
        .doc(Provider.of<MyProvider>(context, listen: false).tasks![taskIndex]
            ["ID"])
        .update(
      {
        "description": newDescription,
      },
    );
  }

  // Récupérer la couleur du thème de la tâche
  Color fetchThemeColor(String? theme) {
    switch (theme) {
      case null:
        return Colors.grey[500]!;
      case "travail":
        return Colors.lightBlue[100]!;
      case "courses":
        return Colors.orange[100]!;
      case "sport":
        return Colors.purple[100]!;
      case "ménage":
        return Colors.yellow[100]!;
      case "rdv":
        return Colors.pink[100]!;
      case "études":
        return Colors.green[100]!;
      default:
        return Colors.grey[500]!;
    }
  }

  // Récupérer la couleur de la priorité de la tâche
  Color fetchPriorityColor(String? priority) {
    switch (priority) {
      case null:
        return Colors.transparent;
      case "high":
        return Colors.red;
      case "mid":
        return Colors.orange;
      case "low":
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }
}

// Popup pour ajouter une tâche
class AddTaskPopup extends StatefulWidget {
  const AddTaskPopup({super.key});

  @override
  State<AddTaskPopup> createState() => _AddTaskPopupState();
}

class _AddTaskPopupState extends State<AddTaskPopup> {
  // Création des Controller
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? themeValue;
  String? priorityValue;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 500,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TextField pour le titre
              MyTextfield(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
                controller: titleController,
                hintText: "Titre (obligatoire)",
                isOneLine: true,
                borderColor: Theme.of(context).colorScheme.primary,
              ),

              // TextField pour la description
              MyTextfield(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.175,
                controller: descriptionController,
                hintText: "Description (facultative)",
                isOneLine: false,
                borderColor: Theme.of(context).colorScheme.primary,
              ),

              // Menu pour sélectionner le thème de la tâche
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: DropdownButton(
                  underline: Container(
                    height: 1.5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  value: themeValue,
                  icon: const Icon(Icons.menu),
                  onChanged: (value) {
                    setState(() {
                      themeValue = value;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text("Choisissez un thème"),
                    ),
                    DropdownMenuItem(
                      value: "travail",
                      child: Row(
                        children: [
                          // Nom du thème
                          Text("Travail"),

                          Gap(25),

                          // Couleur associé au thème
                          Icon(
                            Icons.work,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "courses",
                      child: Row(
                        children: [
                          // Nom du thème
                          Text("Courses"),

                          Gap(25),

                          // Couleur associé au thème
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "sport",
                      child: Row(
                        children: [
                          // Nom du thème
                          Text("Sport"),

                          Gap(25),

                          // Couleur associé au thème
                          Icon(
                            Icons.sports_tennis_rounded,
                            color: Colors.purple,
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "ménage",
                      child: Row(
                        children: [
                          // Nom du thème
                          Text("Ménage"),

                          Gap(25),

                          // Couleur associé au thème
                          Icon(
                            Icons.cleaning_services_rounded,
                            color: Colors.yellow,
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "rdv",
                      child: Row(
                        children: [
                          // Nom du thème
                          Text("Rendez-vous"),

                          Gap(25),

                          // Couleur associé au thème
                          Icon(
                            Icons.event,
                            color: Colors.pink,
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "études",
                      child: Row(
                        children: [
                          // Nom du thème
                          Text("Études"),

                          Gap(25),

                          // Couleur associé au thème
                          Icon(
                            Icons.school,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Menu pour sélectionner la priorité de la tâche
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: DropdownButton(
                  underline: Container(
                    height: 1.5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  value: priorityValue,
                  icon: const Icon(Icons.menu),
                  onChanged: (value) {
                    setState(() {
                      priorityValue = value;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text("Choisissez une priorité"),
                    ),
                    DropdownMenuItem(
                      value: "high",
                      child: Row(
                        children: [
                          // Nom du thème
                          Text("Haute"),

                          Gap(25),

                          // Couleur associé au thème
                          Icon(
                            Icons.circle,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "mid",
                      child: Row(
                        children: [
                          // Nom du thème
                          Text("Moyenne"),

                          Gap(25),

                          // Couleur associé au thème
                          Icon(
                            Icons.circle,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "low",
                      child: Row(
                        children: [
                          // Nom du thème
                          Text("Basse"),

                          Gap(25),

                          // Couleur associé au thème
                          Icon(
                            Icons.circle,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bouton Confirmer
              MyButton(
                color: Theme.of(context).colorScheme.primary,
                text: "Ajouter",
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
                textColor: Theme.of(context).colorScheme.secondary,
                onTap: () async {
                  // Vérifier les entrées utilisateur
                  if (titleController.text.trim() == "") {
                    ErrorHandling().fillTaskTitle.show(context);
                  } else {
                    // Quitter le popup
                    Navigator.of(context).pop();

                    // Récupération du timestamp
                    final int timestamp = DateTime.now().microsecondsSinceEpoch;

                    // Ajouter la tâche dans la base de données
                    await FirebaseFirestore.instance
                        .collection("Users")
                        .doc(Provider.of<MyProvider>(context, listen: false)
                            .user!["ID"])
                        .collection("Tasks")
                        .add(
                      {
                        "title": titleController.text.trim(),
                        "description": descriptionController.text.trim(),
                        "state": false,
                        "theme": themeValue,
                        "priority": priorityValue,
                        "timestamp": timestamp,
                      },
                    ).then(
                      (DocumentReference<Map<String, dynamic>> taskDoc) {
                        // Trouver l'index où doit être stocker la tâche dans le Provider
                        int index =
                            Provider.of<MyProvider>(context, listen: false)
                                .tasks!
                                .indexWhere(
                                  (element) =>
                                      element["priority"] == priorityValue &&
                                      element["timestamp"] > timestamp,
                                );

                        // Ajouter la tâche au Provider
                        if (index == -1) {
                          // Ajouter à la fin
                          Provider.of<MyProvider>(context, listen: false)
                              .addTask(
                            context,
                            Provider.of<MyProvider>(context, listen: false)
                                .tasks!
                                .length,
                            {
                              "ID": taskDoc.id,
                              "title": titleController.text.trim(),
                              "description": descriptionController.text.trim(),
                              "state": false,
                              "theme": themeValue,
                              "priority": priorityValue,
                              "priorityColor": TaskService()
                                  .fetchPriorityColor(priorityValue),
                              "themeColor":
                                  TaskService().fetchThemeColor(themeValue),
                              "images": [],
                              "timestamp": timestamp,
                            },
                          );
                        } else {
                          // Ajouter à l'index correcte
                          Provider.of<MyProvider>(context, listen: false)
                              .addTask(
                            context,
                            index,
                            {
                              "ID": taskDoc.id,
                              "title": titleController.text.trim(),
                              "description": descriptionController.text.trim(),
                              "state": false,
                              "theme": themeValue,
                              "priority": priorityValue,
                              "priorityColor": TaskService()
                                  .fetchPriorityColor(priorityValue),
                              "themeColor":
                                  TaskService().fetchThemeColor(themeValue),
                              "images": [],
                              "timestamp": timestamp,
                            },
                          );
                        }
                      },
                    );
                  }
                },
              ),

              // Bouton Annuler
              MyButton(
                color: Colors.transparent,
                text: "Annuler",
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
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

// AlertDialog pour changer le nom d'une tâche
class ChangeTaskTitleUI extends StatefulWidget {
  final int taskIndex;
  const ChangeTaskTitleUI({
    super.key,
    required this.taskIndex,
  });

  @override
  State<ChangeTaskTitleUI> createState() => _ChangeTaskTitleUIState();
}

class _ChangeTaskTitleUIState extends State<ChangeTaskTitleUI> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = Provider.of<MyProvider>(context, listen: false)
        .tasks![widget.taskIndex]["title"]; // Charger le titre
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
        width: MediaQuery.of(context).size.width * 0.85,
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TextField pour le nouveau nom de la tâche
              MyTextfield(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                controller: _controller,
                hintText: "Titre",
                isOneLine: true,
                borderColor: Theme.of(context).colorScheme.primary,
              ),

              // Bouton appliquer
              MyButton(
                color: Theme.of(context).colorScheme.primary,
                text: "Appliquer",
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
                textColor: Theme.of(context).colorScheme.secondary,
                onTap: () async {
                  // Vérifier les entrées utilisateur
                  if (_controller.text.trim() == "") {
                    ErrorHandling().fillTaskTitle.show(context);
                  } else {
                    // Mettre à jour le titre de la tâche dans la base de données & dans localement dans le Provider
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(Provider.of<MyProvider>(context, listen: false)
                            .user!["ID"])
                        .collection("Tasks")
                        .doc(Provider.of<MyProvider>(context, listen: false)
                            .tasks![widget.taskIndex]["ID"])
                        .update(
                      {
                        "title": _controller.text.trim(),
                      },
                    ).then(
                      (value) {
                        Provider.of<MyProvider>(context, listen: false)
                            .editTask(
                          context,
                          widget.taskIndex,
                          "title",
                          _controller.text.trim(),
                          false,
                        );
                      },
                    );

                    // Pop l'AlertDialog
                    Navigator.pop(context);
                  }
                },
              ),

              // Bouton Annuler
              MyButton(
                color: Colors.transparent,
                text: "Annuler",
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
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
