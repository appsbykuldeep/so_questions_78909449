import 'package:done/pages/task_details_page.dart';
import 'package:done/utilities/my_provider.dart';
import 'package:done/utilities/task_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class MyTaskTile extends StatefulWidget {
  final int taskIndex;
  const MyTaskTile({
    super.key,
    required this.taskIndex,
  });

  @override
  State<MyTaskTile> createState() => _MyTaskTileState();
}

class _MyTaskTileState extends State<MyTaskTile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsPage(
                    taskIndex: widget.taskIndex,
                  ),
                ),
              );
            },
            onLongPress: () {
              showPopover(
                radius: 10.0,
                width: 200,
                height: 50,
                context: context,
                bodyBuilder: (context) {
                  return GestureDetector(
                    onTap: () {
                      // Supprimer la tâche
                      TaskService().deleteTask(
                        context,
                        widget.taskIndex,
                      );
                      // Pop le ContextMenu
                      Navigator.pop(context);
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Supprimer",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: provider.tasks![widget.taskIndex]["themeColor"],
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Image selon le thème de la tâche
                  Image.asset(
                    "assets/${provider.tasks![widget.taskIndex]["theme"]}.png",
                    width: 70,
                  ),

                  // Titre de la tâche
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      provider.tasks![widget.taskIndex]["title"],
                      style: GoogleFonts.exo2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Fait / A faire
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // CheckBox
                      Row(
                        children: [
                          Checkbox(
                            side: const BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                            activeColor: Theme.of(context).colorScheme.primary,
                            value: provider.tasks![widget.taskIndex]["state"],
                            onChanged: (value) {
                              TaskService().editState(
                                context,
                                widget.taskIndex,
                                value!,
                              );
                            },
                          ),
                          Text(
                            provider.tasks![widget.taskIndex]["state"]
                                ? "Terminée"
                                : "À faire",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      Icon(
                        Icons.circle,
                        color: provider.tasks![widget.taskIndex]
                            ["priorityColor"],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
