import "package:flutter/material.dart";

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.black,
    selectionColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    surface: Colors.grey[200]!,
    primary: Colors.black,
    secondary: Colors.white,
    tertiary: Colors.black,
  ),
);
