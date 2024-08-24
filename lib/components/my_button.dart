import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final Color color;
  final String text;
  final double width;
  final double height;
  final Color textColor;
  final void Function()? onTap;
  final Color? borderColor;
  const MyButton({
    super.key,
    required this.color,
    required this.text,
    required this.width,
    required this.height,
    required this.textColor,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: borderColor ?? Colors.black,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.exo2(
              color: textColor,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
