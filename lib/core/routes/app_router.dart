// Rota tanımlamaları (GoRouter veya Navigator)
// Bu dosya uygulamanın navigasyon yapısını yönetir
// Clean Architecture'de CORE katmanında yer alır

import 'package:flutter/material.dart';

// Basit rota tanımlamaları için Navigator kullanımı
// Daha karmaşık uygulamalar için GoRouter tercih edilebilir

class AppRouter {
  // Ana rotalar
  static const String home = '/';
  static const String lesson = '/lesson';
  static const String coding = '/coding';

  // Rota oluşturma fonksiyonu
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        // HomeScreen'e yönlendirme (presentation/screens/home/home_screen.dart)
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // Geçici placeholder
        );
      case lesson:
        // LessonScreen'e yönlendirme (presentation/screens/lesson/lesson_screen.dart)
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // Geçici placeholder
        );
      case coding:
        // CodingScreen'e yönlendirme (presentation/screens/coding/coding_screen.dart)
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // Geçici placeholder
        );
      default:
        return null;
    }
  }

  // Gelecekte GoRouter entegrasyonu için hazır yapı
  // static final GoRouter router = GoRouter(
  //   routes: [
  //     GoRoute(
  //       path: home,
  //       builder: (context, state) => const HomeScreen(),
  //     ),
  //     // Diğer rotalar...
  //   ],
  // );
}
