import "package:flutter/material.dart";

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Colors.black,
  ),
  colorScheme: ColorScheme.dark(
    surface: Colors.grey[800]!,
    primary: Colors.white,
    secondary: Colors.black,
    tertiary: Colors.grey[500],
  ),
);
