// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kodlingo/data/repositories/mock_lesson_data.dart';
import '../../../domain/notifiers/user_notifier.dart';
import '../../widgets/gamification/streak_widget.dart';
import '../../widgets/gamification/can_widget.dart';
import '../../widgets/gamification/xp_widget.dart';
import '../../widgets/lesson_cards/lesson_card_widget.dart';
// Yeni ekranları import et
import '../leaderboard/leaderboard_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Şu an hangi sekmedeyiz?

  // Sekme Listesi
  final List<Widget> _pages = [
    const LessonTreeBody(), // Ana Sayfa (Dersler)
    const LeaderboardScreen(), // Liderlik
    const ProfileScreen(), // Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar sadece "Dersler" sekmesindeyken istatistikleri göstersin
      appBar: _currentIndex == 0 ? _buildHomeAppBar(context) : null,

      // Seçili sayfayı göster
      body: _pages[_currentIndex],

      // Alt Navigasyon Çubuğu
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Dersler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Liderlik',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // Sadece Ana Sayfa için AppBar
  PreferredSizeWidget _buildHomeAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Loopage'), // <-- GÜNCELLENDİ: KodLingo -> Loopage
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [
        Consumer<UserNotifier>(
          builder: (context, userNotifier, child) {
            return XpWidget(xp: userNotifier.user?.xp ?? 0);
          },
        ),
        const SizedBox(width: 8),
        Consumer<UserNotifier>(
          builder: (context, userNotifier, child) {
            return CanWidget(cans: userNotifier.user?.lives ?? 5);
          },
        ),
        const SizedBox(width: 8),
        Consumer<UserNotifier>(
          builder: (context, userNotifier, child) {
            return StreakWidget(streak: userNotifier.user?.currentStreak ?? 0);
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

// Eski HomeScreen içeriğini buraya taşıdık (Ders Listesi)
class LessonTreeBody extends StatelessWidget {
  const LessonTreeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (context, userNotifier, child) {
        if (userNotifier.isLoading) {
          return const Center(child: CircularProgressIndicator());
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
                      'Merhaba, ${userNotifier.user?.username ?? 'Öğrenci'}!',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Python Yolculuğu',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final lesson = MockLessonData.lessons[index];
                final isCompleted = userNotifier.completedLessonIds.contains(
                  lesson.id,
                );

                return LessonCardWidget(
                  lesson: lesson,
                  overrideCompleted: isCompleted,
                );
              }, childCount: MockLessonData.lessons.length),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        );
      },
    );
  }
}
