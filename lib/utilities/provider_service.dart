import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done/utilities/my_provider.dart';
import 'package:done/utilities/task_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class ProviderService {
  // Charger les tâches de l'utilisateur
  Future<void> loadTasks(context) async {
    try {
      List<QueryDocumentSnapshot> orderedTasks = [];

      QuerySnapshot collectionSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(Provider.of<MyProvider>(context, listen: false).user!["ID"])
          .collection("Tasks")
          .orderBy("timestamp", descending: true)
          .get();

      var highPriorityTasks = collectionSnapshot.docs
          .where((doc) => doc['priority'] == 'high')
          .toList();
      var midPriorityTasks = collectionSnapshot.docs
          .where((doc) => doc['priority'] == 'mid')
          .toList();
      var lowPriorityTasks = collectionSnapshot.docs
          .where((doc) => doc['priority'] == 'low')
          .toList();
      var nullPriorityTasks = collectionSnapshot.docs
          .where((doc) => doc['priority'] == null)
          .toList();

      orderedTasks.addAll(highPriorityTasks);
      orderedTasks.addAll(midPriorityTasks);
      orderedTasks.addAll(lowPriorityTasks);
      orderedTasks.addAll(nullPriorityTasks);

      List<Map<String, dynamic>> userTasks = [];

      for (int i = orderedTasks.length; i != 0; i--) {
        List<String> imageList = [];
        DocumentSnapshot taskDoc = orderedTasks[i - 1];
        QuerySnapshot imagesCollection =
            await taskDoc.reference.collection("Images").get();

        for (int j = imagesCollection.docs.length; j != 0; j--) {
          imageList.add(imagesCollection.docs[j - 1]["downloadLink"]);
        }

        userTasks.add(
          {
            "ID": taskDoc.reference.id,
            "title": taskDoc["title"],
            "description": taskDoc["description"],
            "state": taskDoc["state"],
            "theme": taskDoc["theme"],
            "priority": taskDoc["priority"],
            "priorityColor":
                TaskService().fetchPriorityColor(taskDoc["priority"]),
            "themeColor": TaskService().fetchThemeColor(taskDoc["theme"]),
            "images": imageList,
            "timestamp": taskDoc["timestamp"],
          },
        );
      }

      Provider.of<MyProvider>(context, listen: false).setTasks(
        context,
        userTasks.reversed.toList(),
      );
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Erreur",
        text:
            "Une erreur est survenue lors de la récupération de vos tâches ...",
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
        confirmBtnText: "D'accord",
      );
    }
  }

  // Mettre à jour les infos de l'utilisateur
  Future<bool> updateUser(context) async {
    if (FirebaseAuth.instance.currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      Provider.of<MyProvider>(context, listen: false).setUser(
        {
          "ID": FirebaseAuth.instance.currentUser!.uid,
          "isFirstLaunch": userDoc["firstLaunch"],
          "username": userDoc["name"],
          "theme": userDoc["theme"],
        },
      );
      return true;
    } else {
      Provider.of<MyProvider>(context, listen: false).resetProviderInfos();
      Provider.of<MyProvider>(context, listen: false).setUser({});
      return false;
    }
  }

  // Récupérer le pourcentage de tâches terminées
  void updateTaskDonePercentage(
    context,
  ) {
    // Nombre de tâches
    final int taskCount =
        Provider.of<MyProvider>(context, listen: false).tasks!.length;

    // Nombre de tâches terminées
    final int taskDone =
        Provider.of<MyProvider>(context, listen: false).tasks!.where(
      (element) {
        return element["state"] == true;
      },
    ).length;

    // Calcul du pourcentage
    final percentage = taskDone / taskCount;

    Provider.of<MyProvider>(context, listen: false)
        .setTaskDonePercentage(percentage);
  }

  // Trier les tâches dans l'ordre correct (par priorité puis par timestamp)
  void sortTasks(context) {
    List<Map<String, dynamic>> sortedTasks = [];

    List<Map<String, dynamic>> highPriority =
        Provider.of<MyProvider>(context, listen: false)
            .tasks!
            .where((element) => element["priority"] == "high")
            .toList();
    List<Map<String, dynamic>> midPriority =
        Provider.of<MyProvider>(context, listen: false)
            .tasks!
            .where((element) => element["priority"] == "mid")
            .toList();
    List<Map<String, dynamic>> lowPriority =
        Provider.of<MyProvider>(context, listen: false)
            .tasks!
            .where((element) => element["priority"] == "low")
            .toList();
    List<Map<String, dynamic>> noPriority =
        Provider.of<MyProvider>(context, listen: false)
            .tasks!
            .where((element) => element["priority"] == null)
            .toList();

    highPriority.sort((a, b) {
      int dateA = a["timestamp"];
      int dateB = b["timestamp"];
      return dateB.compareTo(dateA);
    });
    midPriority.sort((a, b) {
      int dateA = a["timestamp"];
      int dateB = b["timestamp"];
      return dateB.compareTo(dateA);
    });
    lowPriority.sort((a, b) {
      int dateA = a["timestamp"];
      int dateB = b["timestamp"];
      return dateB.compareTo(dateA);
    });
    noPriority.sort((a, b) {
      int dateA = a["timestamp"];
      int dateB = b["timestamp"];
      return dateB.compareTo(dateA);
    });

    sortedTasks.addAll(highPriority);
    sortedTasks.addAll(midPriority);
    sortedTasks.addAll(lowPriority);
    sortedTasks.addAll(noPriority);

    Provider.of<MyProvider>(context, listen: false).setTasks(
      context,
      sortedTasks,
    );
  }
}
