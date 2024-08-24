import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done/utilities/provider_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyIntroTextfield extends StatefulWidget {
  final int delay;
  const MyIntroTextfield({
    super.key,
    required this.delay,
  });

  @override
  State<MyIntroTextfield> createState() => _MyIntroTextfieldState();
}

class _MyIntroTextfieldState extends State<MyIntroTextfield>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    Timer(
      Duration(milliseconds: widget.delay),
      () {
        _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
        child: ClipRRect(
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(18.0),
          ),
          child: Container(
            color: const Color(0xFFE3E8EF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Appuyer pour commencer ...",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update(
                      {
                        "firstLaunch": false,
                      },
                    ).then(
                      (value) {
                        ProviderService().updateUser(context);
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(18.0),
                    ),
                    child: Container(
                      width: 130,
                      height: 60,
                      color: const Color(0xFF005EDE),
                      child: Center(
                        child: Text(
                          "Commencer",
                          style: GoogleFonts.exo2(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
