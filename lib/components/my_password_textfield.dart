import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MyPasswordTextfield extends StatefulWidget {
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final String? hintText;
  final Color? hintTextColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? visibilityColor;
  const MyPasswordTextfield({
    super.key,
    required this.width,
    required this.height,
    required this.controller,
    required this.hintText,
    this.hintTextColor,
    this.borderColor,
    this.textColor,
    this.visibilityColor,
  });

  @override
  State<MyPasswordTextfield> createState() => _MyPasswordTextfieldState();
}

class _MyPasswordTextfieldState extends State<MyPasswordTextfield> {
  bool obscureText = true;

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Textfield
            Expanded(
              child: TextField(
                style: TextStyle(color: widget.textColor),
                controller: widget.controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: widget.hintTextColor ?? const Color(0xFFC1C3C1),
                  ),
                ),
                obscureText: obscureText,
              ),
            ),

            const Gap(10),

            // Oeil de visibilité
            GestureDetector(
              onTap: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              child: Icon(
                obscureText
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: widget.visibilityColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
