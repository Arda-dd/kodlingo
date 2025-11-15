// Ana ekran - Ders ağacı ve seri görünümü
// Bu dosya PRESENTATION katmanında yer alır ve UI'ı yönetir
// DOMAIN katmanındaki notifiers'ı kullanarak state'i görüntüler

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/notifiers/user_notifier.dart';
import '../../widgets/gamification/streak_widget.dart';
import '../../widgets/gamification/can_widget.dart';
import '../../widgets/gamification/xp_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KodLingo'),
        actions: [
          // XP göstergesi
          Consumer<UserNotifier>(
            builder: (context, userNotifier, child) {
              return XpWidget(xp: userNotifier.user?.xp ?? 0);
            },
          ),
          const SizedBox(width: 16),
          // Can göstergesi
          Consumer<UserNotifier>(
            builder: (context, userNotifier, child) {
              return CanWidget(cans: userNotifier.user?.lives ?? 5);
            },
          ),
          const SizedBox(width: 16),
          // Seri göstergesi
          Consumer<UserNotifier>(
            builder: (context, userNotifier, child) {
              return StreakWidget(
                streak: userNotifier.user?.currentStreak ?? 0,
              );
            },
          ),
        ],
      ),
      body: Consumer<UserNotifier>(
        builder: (context, userNotifier, child) {
          if (userNotifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userNotifier.error != null) {
            return Center(child: Text('Hata: ${userNotifier.error}'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merhaba, ${userNotifier.user?.username ?? 'Kullanıcı'}!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ders Ağacı',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Ders ağacı görünümü (gelecekte implement edilecek)
                Expanded(
                  child: Center(
                    child: Text(
                      'Ders ağacı burada görüntülenecek',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
