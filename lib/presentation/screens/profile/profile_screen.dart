// lib/presentation/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/notifiers/user_notifier.dart';
import '../../widgets/common/custom_button.dart';
import '../../../core/routes/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (context, userNotifier, _) {
        final user = userNotifier.user;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Profil Resmi
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.purple.shade200,
                    child: Text(
                      user?.username.substring(0, 1).toUpperCase() ?? 'K',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // İsim ve Email
                  Text(
                    user?.username ?? 'Misafir',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                  ),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 32),

                  // İstatistik Kartları
                  Row(
                    children: [
                      _buildStatCard(
                        context,
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                        value: '${user?.currentStreak ?? 0}',
                        label: 'Gün Seri',
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        context,
                        icon: Icons.star,
                        color: Colors.yellow,
                        value: '${user?.xp ?? 0}',
                        label: 'Toplam XP',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tamamlanan Ders İstatistiği
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tamamlanan Dersler',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          '${userNotifier.completedLessonIds.length}', // UserNotifier'dan alıyoruz
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Ayarlar Bölümü (Mock)
                  const Divider(color: Colors.white24),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white70),
                    title: const Text(
                      'Ayarlar',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white54,
                    ),
                    onTap: () {
                      // --- GÜNCELLEME BURADA ---
                      Navigator.of(context).pushNamed(AppRouter.settings);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text(
                      'Çıkış Yap',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onTap: () {
                      // Çıkış yapma mantığı
                      userNotifier.logout();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
