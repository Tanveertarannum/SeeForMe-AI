import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFF4F8F7);
  static const Color paper = Color(0xFFFCFDFC);
  static const Color mist = Color(0xFFE4F0F0);
  static const Color sky = Color(0xFFC9E1E3);
  static const Color teal = Color(0xFF4E8E90);
  static const Color deepTeal = Color(0xFF285B60);
  static const Color text = Color(0xFF1F2C2D);
  static const Color muted = Color(0xFF748284);
  static const Color sage = Color(0xFF8FA89C);
  static const Color warning = Color(0xFFC78658);
  static const Color danger = Color(0xFFB85D59);

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    fontFamily: 'Arial',

    colorScheme: ColorScheme.fromSeed(
      seedColor: teal,
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: text,
    ),

    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );
}