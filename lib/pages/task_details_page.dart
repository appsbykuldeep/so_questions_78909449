import 'package:done/components/my_button.dart';
import 'package:done/components/my_textfield.dart';
import 'package:done/utilities/image_service.dart';
import 'package:done/utilities/my_provider.dart';
import 'package:done/utilities/provider_service.dart';
import 'package:done/utilities/task_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class TaskDetailsPage extends StatefulWidget {
  final int taskIndex;
  const TaskDetailsPage({
    super.key,
    required this.taskIndex,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _descriptionController.text =
        Provider.of<MyProvider>(context, listen: false).tasks![widget.taskIndex]
            ["description"]; // Charger la description
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, provider, _) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              // Trier les tâches
              ProviderService().sortTasks(context);

              // Mettre à jour la description
              TaskService().editDescription(
                context,
                widget.taskIndex,
                _descriptionController.text.trim(),
              );
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              leading: IconButton(
                onPressed: () {
                  // Quitter la page
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black,
                ),
              ),
              backgroundColor: provider.tasks![widget.taskIndex]["themeColor"],
              title: Text(
                provider.tasks![widget.taskIndex]["title"],
                style: GoogleFonts.exo2(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    TaskService().editTitle(
                      context,
                      widget.taskIndex,
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Visualisation du thème de la tâche (et modification de celui ci)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/${provider.tasks![widget.taskIndex]["theme"]}.png",
                              width: 125,
                            ),
                            Transform.scale(
                              scale: 1.2,
                              child: DropdownButton(
                                underline: Container(
                                  height: 1.5,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                value: provider.tasks![widget.taskIndex]
                                    ["theme"],
                                icon: const Icon(Icons.menu),
                                onChanged: (value) {
                                  TaskService().editTheme(
                                    context,
                                    widget.taskIndex,
                                    value,
                                  );
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
                          ],
                        ),

                        Divider(
                          color: Theme.of(context).colorScheme.primary,
                          height: 50,
                        ),

                        // Indicateur de fait / pas fait
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Transform.scale(
                              scale: 1.4,
                              child: Checkbox(
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                value: provider.tasks![widget.taskIndex]
                                    ["state"],
                                onChanged: (value) {
                                  TaskService().editState(
                                    context,
                                    widget.taskIndex,
                                    value!,
                                  );
                                },
                              ),
                            ),
                            Text(
                              provider.tasks![widget.taskIndex]["state"]
                                  ? "Terminée"
                                  : " faire",
                              style: GoogleFonts.exo2(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              "assets/${provider.tasks![widget.taskIndex]["state"]}.png",
                              width: 50,
                            ),
                          ],
                        ),

                        Divider(
                          color: Theme.of(context).colorScheme.primary,
                          height: 50,
                        ),

                        // Row pour gérer la priorité de la tâche
                        Row(
                          children: [
                            // Texte
                            Text(
                              "La tâche a une priorité :",
                              style: GoogleFonts.exo2(),
                            ),

                            const Gap(15),

                            // DropdownButton
                            SizedBox(
                              child: DropdownButton(
                                underline: Container(
                                  height: 1.5,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                value: provider.tasks![widget.taskIndex]
                                    ["priority"],
                                icon: const Icon(Icons.menu),
                                onChanged: (value) {
                                  TaskService().editPriority(
                                    context,
                                    widget.taskIndex,
                                    value,
                                  );
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
                          ],
                        ),

                        Divider(
                          color: Theme.of(context).colorScheme.primary,
                          height: 50,
                        ),

                        // TextField de description
                        MyTextfield(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.3,
                          controller: _descriptionController,
                          hintText: "Description",
                          isOneLine: false,
                          borderColor: Theme.of(context).colorScheme.primary,
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.primary,
                          height: 50,
                        ),

                        // Image associé à la tâche
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Image",
                              style: GoogleFonts.exo2(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ImageService().addImageToTask(
                                  context,
                                  widget.taskIndex,
                                );
                              },
                              icon: const Icon(
                                Icons.upload,
                                size: 30,
                              ),
                            ),
                          ],
                        ),

                        // Images
                        SizedBox(
                          height: provider
                                  .tasks![widget.taskIndex]["images"].isEmpty
                              ? 0
                              : 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider
                                .tasks![widget.taskIndex]["images"].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CupertinoContextMenu(
                                  actions: [
                                    CupertinoContextMenuAction(
                                      onPressed: () {
                                        ImageService().deleteImage(
                                            context,
                                            provider.tasks![widget.taskIndex]
                                                ["images"][index],
                                            widget.taskIndex,
                                            index);
                                      },
                                      isDestructiveAction: true,
                                      trailingIcon: Icons.delete_forever,
                                      child: const Text("Supprimer"),
                                    ),
                                  ],
                                  child: Image.network(
                                    provider.tasks![widget.taskIndex]["images"]
                                        [index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        Divider(
                          color: Theme.of(context).colorScheme.primary,
                          height: 50,
                        ),

                        // Bouton supprimer la tâche
                        MyButton(
                          color: Theme.of(context).colorScheme.primary,
                          text: "Supprimer la tâche",
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: 50,
                          textColor: Theme.of(context).colorScheme.secondary,
                          onTap: () {
                            // Afficher un popup de confirmation
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              text:
                                  "Êtes-vous sûr de vouloir supprimer cette tâche ?\n"
                                  "La suppression d'une tâche est irréversible.",
                              title: "Suppression de la tâche",
                              onCancelBtnTap: () {
                                // Fermer le popup
                                Navigator.pop(context);
                              },
                              cancelBtnText: "Non",
                              showCancelBtn: true,
                              onConfirmBtnTap: () {
                                // Quitter le popup
                                Navigator.pop(context);

                                // Quitter la page de détail de la tâche
                                Navigator.pop(context);

                                // Supprimer la tâche
                                TaskService().deleteTask(
                                  context,
                                  widget.taskIndex,
                                );
                              },
                              confirmBtnText: "Oui",
                              confirmBtnColor: Colors.black,
                            );
                          },
                        ),

                        Gap(MediaQuery.of(context).viewInsets.bottom),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
