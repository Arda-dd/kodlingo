// lib/core/routes/app_router.dart

import 'package:flutter/material.dart';
// Ekranların hepsini import ediyoruz
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/coding/coding_screen.dart';
import '../../presentation/screens/lesson/lesson_screen.dart';
import '../../presentation/screens/result/lesson_success_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart'; // <-- EKLENDİ

class AppRouter {
  // Rota İsimleri (Sabitler)
  static const String login = '/';
  static const String register = '/register';
  static const String home = '/home';
  static const String coding = '/coding';
  static const String lesson = '/lesson';
  static const String lessonSuccess = '/lesson-success';
  static const String settings = '/settings'; // <-- EKLENDİ (Hata buradaydı)

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case coding:
        final lessonId = settings.arguments as int? ?? 1;
        return MaterialPageRoute(
            builder: (_) => CodingScreen(lessonId: lessonId));

      case AppRouter.settings: // <-- Ayarlar Sayfası Yönlendirmesi
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case lesson:
        // Gelen veriyi güvenli şekilde alıyoruz
        final lessonId = settings.arguments;
        if (lessonId is int) {
          return MaterialPageRoute(
            builder: (_) => LessonScreen(lessonId: lessonId),
          );
        }
        // Hata durumunda (String gelirse vs.) varsayılan bir değerle aç
        return MaterialPageRoute(
          builder: (_) => const LessonScreen(lessonId: 1),
        );

      case lessonSuccess:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => LessonSuccessScreen(
            earnedXp: args?['earnedXp'] ?? 0,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Rota bulunamadı: ${settings.name}')),
          ),
        );
    }
  }
}
