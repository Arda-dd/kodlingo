// lib/presentation/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/notifiers/user_notifier.dart';
import '../../widgets/common/custom_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userNotifier = Provider.of<UserNotifier>(context);
    final user = userNotifier.user;

    return Scaffold(
      backgroundColor: Colors.black, // Tüm sayfa arka planı tam siyah
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profil Başlığı
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFF4CAF50), width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          Color(0xFF1E1E1E), // Profil ikonu arkası koyu gri
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.username ?? 'Kullanıcı',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // İstatistikler Kartı (Siyah ve Modern)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF121212), // Kart içi siyah/koyu gri
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                      'XP', '${user?.xp ?? 0}', Icons.bolt, Colors.orange),
                  _buildStatItem(
                      'Can', '${user?.lives ?? 0}', Icons.favorite, Colors.red),
                  _buildStatItem('Seri', '${user?.currentStreak ?? 0}',
                      Icons.local_fire_department, Colors.orangeAccent),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menü Seçenekleri Kartı
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121212), // Kart içi siyah/koyu gri
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.settings,
                    title: 'Ayarlar',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRouter.settings),
                  ),
                  Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  _buildMenuTile(
                    icon: Icons.help_outline,
                    title: 'Yardım ve Destek',
                    onTap: () {},
                  ),
                  Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  _buildMenuTile(
                    icon: Icons.logout,
                    title: 'Çıkış Yap',
                    color: Colors.redAccent,
                    onTap: () async {
                      await userNotifier.logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRouter.login,
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: onTap,
    );
  }
}
