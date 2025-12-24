// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- Bunu eklemeyi unutma
import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide ChangeNotifierProvider, Provider;
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/user_local_provider.dart';
import 'domain/notifiers/user_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    // Kullanıcı giriş yapmış mı kontrol et (Tek satırda)
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return MaterialApp(
      title: 'Loopage',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Eğer giriş yapmışsa Home, yapmamışsa Login aç:
      initialRoute: isLoggedIn ? AppRouter.home : AppRouter.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
