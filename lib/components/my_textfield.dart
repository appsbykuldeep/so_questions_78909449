import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final String? hintText;
  final bool isOneLine;
  final Color? hintTextColor;
  final Color? textColor;
  final Color? borderColor;
  const MyTextfield({
    super.key,
    required this.width,
    required this.height,
    required this.controller,
    required this.hintText,
    required this.isOneLine,
    this.hintTextColor,
    this.textColor,
    this.borderColor,
  });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: widget.borderColor ?? Colors.black,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextField(
          style: TextStyle(color: widget.textColor),
          expands: !widget.isOneLine,
          maxLines: widget.isOneLine ? 1 : null,
          controller: widget.controller,
          decoration: InputDecoration(
            counterText: "",
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: widget.hintTextColor ?? const Color(0xFFC1C3C1),
            ),
          ),
        ),
      ),
    );
  }
}
