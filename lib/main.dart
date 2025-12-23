// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // <-- YENİ EKLENDİ
import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide ChangeNotifierProvider, Provider;
import 'package:provider/provider.dart';

import 'firebase_options.dart'; // <-- YENİ EKLENDİ (Az önce oluşan dosya)
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/user_local_provider.dart';
import 'domain/notifiers/user_notifier.dart';

void main() async {
  // <-- async EKLENDİ
  WidgetsFlutterBinding
      .ensureInitialized(); // <-- YENİ EKLENDİ (Hata almamak için şart)

  // Firebase'i başlatıyoruz
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
      child: ChangeNotifierProvider(
        create: (context) => UserNotifier(UserLocalProvider())..loadUser(),
        child: const LoopageApp(),
      ),
    ),
  );
}

class LoopageApp extends StatelessWidget {
  const LoopageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loopage',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
