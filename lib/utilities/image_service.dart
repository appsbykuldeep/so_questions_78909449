import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done/components/my_button.dart';
import 'package:done/utilities/my_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageService {
  void addImageToTask(context, int taskIndex) async {
    File? image;
    // --- Popup ---
    await showDialog(
      context: context,
      builder: (context) {
        return AddImageToTaskPopup(
          image: image,
          taskIndex: taskIndex,
        );
      },
    );
  }

  void deleteImage(
      context, String downloadLink, int taskIndex, int imageIndex) async {
    // Supprimer l'image de Firebase Firestore
    QuerySnapshot imageCollectionSnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Tasks")
        .doc(Provider.of<MyProvider>(context, listen: false).tasks![taskIndex]
            ["ID"])
        .collection("Images")
        .get();
    imageCollectionSnapshot.docs[imageIndex].reference.delete();
    Provider.of<MyProvider>(context, listen: false).editTask(
      context,
      taskIndex,
      "images",
      imageCollectionSnapshot.docs[imageIndex]["downloadLink"],
      true,
    );

    // Supprimer l'image de Firebase Storage
    Reference imageReference =
        FirebaseStorage.instance.refFromURL(downloadLink);
    await imageReference.delete();

    Navigator.pop(context);
  }
}

class AddImageToTaskPopup extends StatefulWidget {
  File? image;
  int taskIndex;

  AddImageToTaskPopup({
    super.key,
    required this.image,
    required this.taskIndex,
  });

  @override
  State<AddImageToTaskPopup> createState() => _AddImageToTaskPopupState();
}

class _AddImageToTaskPopupState extends State<AddImageToTaskPopup> {
  late MyProvider myProvider;

  @override
  void didChangeDependencies() {
    myProvider = Provider.of<MyProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Source de l'image :",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              MyButton(
                color: Colors.transparent,
                text: "Galerie",
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                textColor: Theme.of(context).colorScheme.primary,
                borderColor: Theme.of(context).colorScheme.primary,
                onTap: () async {
                  // Quitter le popup
                  Navigator.pop(context);

                  // Choisir les images
                  List<XFile?> baseImagesList =
                      await ImagePicker().pickMultiImage();

                  // Pour chaque image, la lier à la tâche et l'uploader sur la base de données
                  for (XFile? baseImage in baseImagesList) {
                    if (baseImage != null) {
                      widget.image = File(baseImage.path);

                      // Récupérer l'ID de l'utilisateur
                      final String userID =
                          FirebaseAuth.instance.currentUser!.uid;

                      // Récupérer l'ID du document de la tâche
                      final String docID = FirebaseFirestore.instance
                          .collection("Users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("Tasks")
                          .doc(myProvider.tasks![widget.taskIndex]["ID"])
                          .id;

                      // Récupération de la référence de base de Firebase Storage
                      final storageRef = FirebaseStorage.instance.ref();

                      // Récupérer un timestamp unique
                      final int time = DateTime.now().microsecondsSinceEpoch;

                      // Récupérer le nom du fichier
                      final String fileName =
                          widget.image!.path.split("/").last;

                      // Récupérer la référence de là où va être placer l'image
                      final imagePath =
                          storageRef.child("$userID/$docID/$time-$fileName");

                      // Ajouter l'image à son chemin
                      imagePath.putFile(widget.image!).whenComplete(
                        () async {
                          // Ajouter le downloadLink de l'image dans Firebase Firestore
                          final String downloadLink =
                              await imagePath.getDownloadURL();

                          // Mettre à jour l'interface
                          myProvider.editTask(
                            context,
                            widget.taskIndex,
                            "images",
                            downloadLink,
                            false,
                          );

                          // Mettre à jour la db
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(userID)
                              .collection("Tasks")
                              .doc(docID)
                              .collection("Images")
                              .add(
                            {
                              "downloadLink": downloadLink,
                            },
                          );
                        },
                      );
                    }
                  }
                },
              ),
              MyButton(
                color: Colors.transparent,
                text: "Appareil photo",
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                textColor: Theme.of(context).colorScheme.primary,
                borderColor: Theme.of(context).colorScheme.primary,
                onTap: () async {
                  // Quitter le popup
                  Navigator.pop(context);

                  var baseImage =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (baseImage != null) {
                    widget.image = File(baseImage.path);

                    // Récupérer l'ID de l'utilisateur
                    final String userID =
                        FirebaseAuth.instance.currentUser!.uid;

                    // Récupérer l'ID du document de la tâche
                    final String docID = FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("Tasks")
                        .doc(myProvider.tasks![widget.taskIndex]["ID"])
                        .id;

                    // Récupération de la référence de base de Firebase Storage
                    final storageRef = FirebaseStorage.instance.ref();

                    // Récupérer un timestamp unique
                    final int time = DateTime.now().microsecondsSinceEpoch;

                    // Récupérer le nom du fichier
                    final String fileName = widget.image!.path.split("/").last;

                    // Récupérer la référence de là où va être placer l'image
                    final imagePath =
                        storageRef.child("$userID/$docID/$time-$fileName");

                    // Ajouter l'image à son chemin
                    imagePath.putFile(widget.image!).whenComplete(
                      () async {
                        // Ajouter le downloadLink de l'image dans Firebase Firestore
                        final String downloadLink =
                            await imagePath.getDownloadURL();

                        // Mettre à jour l'interface
                        myProvider.editTask(
                          context,
                          widget.taskIndex,
                          "images",
                          downloadLink,
                          false,
                        );

                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(userID)
                            .collection("Tasks")
                            .doc(docID)
                            .collection("Images")
                            .add(
                          {
                            "downloadLink": downloadLink,
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
