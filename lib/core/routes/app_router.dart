// lib/core/routes/app_router.dart

import 'package:flutter/material.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/lesson/lesson_screen.dart';
import '../../presentation/screens/coding/coding_screen.dart';

class AppRouter {
  // Ana rotalar
  static const String home = '/';
  static const String lesson = '/lesson';
  static const String coding = '/coding';

  // Rota oluşturma fonksiyonu
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case lesson:
        // LessonScreen için argümanları yakalama
        final args = settings.arguments as Map<String, dynamic>?;
        final lessonId = args?['lessonId'] as int? ?? 1;

        return MaterialPageRoute(
          builder: (_) => LessonScreen(lessonId: lessonId),
        );
      case coding:
        // CodingScreen için argümanları yakalama
        final args = settings.arguments as Map<String, dynamic>?;
        final lessonId = args?['lessonId'] as int? ?? 1;

        return MaterialPageRoute(
          builder: (_) => CodingScreen(lessonId: lessonId),
        );
      default:
        return null;
    }
  }
}
