// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kodlingo/data/repositories/mock_lesson_data.dart';
import '../../../domain/notifiers/user_notifier.dart';
import '../../widgets/gamification/streak_widget.dart';
import '../../widgets/gamification/can_widget.dart';
import '../../widgets/gamification/xp_widget.dart';
import '../../widgets/lesson_cards/lesson_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KodLingo'),
        actions: [
          Consumer<UserNotifier>(
            builder: (context, userNotifier, child) {
              return XpWidget(xp: userNotifier.user?.xp ?? 0);
            },
          ),
          const SizedBox(width: 16),
          Consumer<UserNotifier>(
            builder: (context, userNotifier, child) {
              return CanWidget(cans: userNotifier.user?.lives ?? 5);
            },
          ),
          const SizedBox(width: 16),
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

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Merhaba, ${userNotifier.user?.username ?? 'Kullanıcı'}!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Python Ders Ağacı',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // Ders Ağacı Görünümü
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final lesson = MockLessonData.lessons[index];

                  // --- GÜNCELLENEN KISIM ---
                  // UserNotifier'daki tamamlanan listesine bakıyoruz
                  final isCompleted = userNotifier.completedLessonIds.contains(
                    lesson.id,
                  );

                  return LessonCardWidget(
                    lesson: lesson,
                    overrideCompleted:
                        isCompleted, // Durumu widget'a bildiriyoruz
                  );
                }, childCount: MockLessonData.lessons.length),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}
