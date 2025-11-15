// Uygulamanın ThemeData tanımı
// Bu dosya uygulamanın genel görünümünü ve tema ayarlarını yönetir
// Clean Architecture'de CORE katmanında yer alır, UI'dan bağımsızdır

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  // Ana tema tanımı
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Color(AppConstants.primaryColor),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(AppConstants.primaryColor),
        secondary: Color(AppConstants.secondaryColor),
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
    );
  }

  // Karanlık tema (gelecekte eklenebilir)
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      // Karanlık tema özelleştirmeleri buraya eklenebilir
    );
  }
}
