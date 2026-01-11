import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(),
  textTheme: const TextTheme(),
);

final ThemeData pureBlackTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    surface: Color(0xff000000),
    surfaceContainerHighest: Color(0xff1a1a1a),
  ),
  scaffoldBackgroundColor: const Color(0xff000000),
  textTheme: const TextTheme(),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: Color(0xffbd93f9),
    secondary: Color(0xffff79c6),
    surface: Color(0xff282a36),
    surfaceContainerHighest: Color(0xff44475a),
  ),
  scaffoldBackgroundColor: const Color(0xff282a36),
  textTheme: const TextTheme(),
);
