// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide ChangeNotifierProvider, Provider;
import 'package:provider/provider.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/user_local_provider.dart';
import 'domain/notifiers/user_notifier.dart';

// Ana uygulama başlatma noktası
void main() {
  runApp(
    // ProviderScope ve ChangeNotifierProvider ile sarılır
    ProviderScope(
      child: ChangeNotifierProvider(
        create: (context) => UserNotifier(UserLocalProvider())..loadUser(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Temayı CORE katmanından karanlık temayı alacak şekilde güncelledik.
    return MaterialApp(
      title: 'KodLingo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // <<< Siyah Tema Uygulandı
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
