// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  // Ana tema tanımı (Açık Tema)
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Color(AppConstants.primaryColor),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(AppConstants.primaryColor),
        secondary: Color(AppConstants.secondaryColor),
        brightness: Brightness.light,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16.0, height: 1.5),
        bodyMedium: TextStyle(fontSize: 14.0, height: 1.4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(AppConstants.primaryColor),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
      ),
    );
  }

  // Karanlık tema (Siyah Tema) - Geliştirilmiş sürüm
  static ThemeData get darkTheme {
    const Color darkPrimary = Color(0xFF81D4FA); // Görünürlük için açık mavi
    const Color darkBackground = Color(0xFF121212); // Koyu Gri/Siyah
    const Color darkSurface = Color(0xFF1E1E1E); // Kartlar, AppBar için

    return ThemeData(
      primaryColor: darkPrimary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkPrimary,
        secondary: Color(AppConstants.secondaryColor),
        brightness: Brightness.dark,
        background: darkBackground,
        surface: darkSurface,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          height: 1.5,
          color: Colors.white70,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          height: 1.4,
          color: Colors.white70,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        elevation: 0, // Koyu temada gölgeler kaybolur
      ),
    );
  }
}
