// lib/core/routes/app_router.dart

import 'package:flutter/material.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/lesson/lesson_screen.dart';
import '../../presentation/screens/coding/coding_screen.dart';
import '../../presentation/screens/result/lesson_success_screen.dart';
// Yeni import:
import '../../presentation/screens/settings/settings_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String lesson = '/lesson';
  static const String coding = '/coding';
  static const String lessonSuccess = '/lesson_success';
  static const String settings = '/settings'; // <--- Yeni Rota Tanımı

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case lesson:
        final args = settings.arguments as Map<String, dynamic>?;
        final lessonId = args?['lessonId'] as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) => LessonScreen(lessonId: lessonId),
        );
      case coding:
        final args = settings.arguments as Map<String, dynamic>?;
        final lessonId = args?['lessonId'] as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) => CodingScreen(lessonId: lessonId),
        );
      case lessonSuccess:
        final args = settings.arguments as Map<String, dynamic>?;
        final xp = args?['earnedXp'] as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => LessonSuccessScreen(earnedXp: xp),
        );

      // AŞAĞIDAKİ KISMI EKLEYİN:
      case AppRouter.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      default:
        return null;
    }
  }
}
