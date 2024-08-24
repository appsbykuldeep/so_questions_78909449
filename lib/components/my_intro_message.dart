import 'dart:async';

import 'package:flutter/material.dart';

class MyIntroMessage extends StatefulWidget {
  final String? message;
  final int delay;
  const MyIntroMessage({
    super.key,
    required this.message,
    required this.delay,
  });

  @override
  State<MyIntroMessage> createState() => _MyIntroMessageState();
}

class _MyIntroMessageState extends State<MyIntroMessage>
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
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.2,
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: const Color(0xFFE3E8EF),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(widget.message ??
              "Aucun message n'a été fourni lors du développement."),
        ),
      ),
    );
  }
}
