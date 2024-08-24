import 'dart:async';

import 'package:flutter/material.dart';

class MyMessage extends StatefulWidget {
  final String? message;
  final int delay;
  const MyMessage({
    super.key,
    required this.message,
    required this.delay,
  });

  @override
  State<MyMessage> createState() => _MyMessageState();
}

class _MyMessageState extends State<MyMessage>
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
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: const BoxDecoration(
          color: Color(0xFFFFC9D6),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(25),
          ),
        ),
        child: Text(widget.message ??
            "Aucun message n'a été fourni lors du développement."),
      ),
    );
  }
}
