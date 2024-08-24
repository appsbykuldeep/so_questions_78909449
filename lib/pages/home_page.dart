import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done/components/my_task_tile.dart';
import 'package:done/pages/account_page.dart';
import 'package:done/utilities/my_provider.dart';
import 'package:done/utilities/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          floatingActionButton: Visibility(
            visible: provider.tasks
                    ?.where((element) => element["state"])
                    .isNotEmpty ??
                false,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 125),
              opacity: (provider.tasks
                          ?.where((element) => element["state"])
                          .isNotEmpty ??
                      false)
                  ? 1
                  : 0,
              child: FloatingActionButton(
                onPressed: () async {
                  TaskService().deleteDoneTasks(context);

                  // Initialisation de la liste des ID de tâches à supprimer
                  List<String> taskDone = [];

                  // Récupérer le nombre de tâche existante
                  QuerySnapshot collectionSnapshot = await FirebaseFirestore
                      .instance
                      .collection("Users")
                      .doc(provider.user!["ID"])
                      .collection("Tasks")
                      .get();

                  // Pour chaque tâche existante, ajouter son ID à la liste si la tâche est terminée
                  for (int taskNumber = collectionSnapshot.docs.length;
                      taskNumber > 0;
                      taskNumber--) {
                    bool isTaskDone =
                        collectionSnapshot.docs[taskNumber - 1]["state"];
                    if (isTaskDone) {
                      String taskID =
                          collectionSnapshot.docs[taskNumber - 1].reference.id;
                      taskDone.add(taskID);
                    }
                  }

                  // Pour chaque ID dans la liste, supprimer la tâche associée
                  for (String taskID in taskDone) {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(provider.user!["ID"])
                        .collection("Tasks")
                        .doc(taskID)
                        .delete();
                  }
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Message de bienvenue
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AccountPage()));
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "Bonjour,\n",
                              style: GoogleFonts.exo2(
                                fontSize: 40,
                                height: 1.25,
                              ),
                              children: [
                                TextSpan(
                                  text: provider.user!["username"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if (provider.tasks!.isEmpty)
                          GestureDetector(
                            onTap: () {
                              TaskService().showAddTaskPopup(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(25.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 1.5,
                                    color: Color.fromRGBO(189, 189, 189, 1),
                                  ),
                                  bottom: BorderSide(
                                    width: 1.5,
                                    color: Color.fromRGBO(189, 189, 189, 1),
                                  ),
                                  left: BorderSide(
                                    width: 1.5,
                                    color: Color.fromRGBO(189, 189, 189, 1),
                                  ),
                                ),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(18.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Icon +
                                  const Icon(
                                    Icons.add,
                                    size: 30,
                                  ),

                                  // Texte
                                  Text(
                                    "Ajouter une tâche",
                                    style: GoogleFonts.exo2(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        if (provider.taskDonePercentage != null &&
                            provider.tasks!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 25.0),
                            child: CircularPercentIndicator(
                              radius: 50,
                              percent: provider.taskDonePercentage!,
                              progressColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor: Colors.blueGrey[200]!,
                              lineWidth: 8,
                              center: Text(
                                "${(provider.taskDonePercentage! * 100).round().toString()}%",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Divider(),
                  ),
                  Expanded(
                    child: provider.tasks!.isEmpty
                        ? Image.asset("assets/no_task.png")
                        : Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: MasonryGridView.count(
                              cacheExtent: double.infinity,
                              itemCount: provider.tasks!.length + 1,
                              crossAxisCount: 2,
                              itemBuilder: (context, index) {
                                if (index == 1) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        TaskService().showAddTaskPopup(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(25.0),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              width: 1.5,
                                              color: Color.fromRGBO(
                                                  189, 189, 189, 1),
                                            ),
                                            bottom: BorderSide(
                                              width: 1.5,
                                              color: Color.fromRGBO(
                                                  189, 189, 189, 1),
                                            ),
                                            left: BorderSide(
                                              width: 1.5,
                                              color: Color.fromRGBO(
                                                  189, 189, 189, 1),
                                            ),
                                          ),
                                          borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(18.0),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            // Icon +
                                            const Icon(
                                              Icons.add,
                                              size: 30,
                                            ),

                                            // Texte
                                            Text(
                                              "Ajouter une tâche",
                                              style: GoogleFonts.exo2(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: MyTaskTile(taskIndex: index),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: MyTaskTile(taskIndex: index - 1),
                                  );
                                }
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
