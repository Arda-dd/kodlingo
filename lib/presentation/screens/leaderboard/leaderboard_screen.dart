// lib/presentation/screens/leaderboard/leaderboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/notifiers/user_notifier.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock (Sahte) Liderlik Verisi
    final List<Map<String, dynamic>> fakeUsers = [
      {'name': 'Python Ustası', 'xp': 2500, 'avatar': Icons.emoji_events},
      {'name': 'Kod Canavarı', 'xp': 1850, 'avatar': Icons.person},
      {'name': 'Gizemli Yazılımcı', 'xp': 1200, 'avatar': Icons.person_outline},
      {'name': 'Dart Sever', 'xp': 950, 'avatar': Icons.code},
      {'name': 'Flutter Fan', 'xp': 800, 'avatar': Icons.phone_android},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Üst Başlık Alanı
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              children: [
                const Text(
                  'Liderlik Tablosu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Arkadaşlarınla yarış ve zirveye çık!',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // Liste
          Expanded(
            child: ListView.builder(
              itemCount: fakeUsers.length + 1, // +1 Bizim kullanıcımız için
              itemBuilder: (context, index) {
                // Listeye kendi kullanıcımızı ekleyelim (Örneğin 3. sıraya koyalım simülasyon için)
                if (index == 2) {
                  return _buildCurrentUserRow(context);
                }

                // Diğer sahte kullanıcılar
                final userIndex = index > 2 ? index - 1 : index;
                final user = fakeUsers[userIndex];

                return _buildUserRow(
                  context,
                  rank: index + 1,
                  name: user['name'],
                  xp: user['xp'],
                  icon: user['avatar'],
                  isMe: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserRow(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (context, userNotifier, _) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1), // Vurgulu arka plan
            border: Border.symmetric(
              horizontal: BorderSide(color: Colors.amber.withOpacity(0.3)),
            ),
          ),
          child: _buildUserRow(
            context,
            rank: 3, // Şimdilik sabit sıra
            name: userNotifier.user?.username ?? 'Sen',
            xp: userNotifier.user?.xp ?? 0,
            icon: Icons.account_circle,
            isMe: true,
          ),
        );
      },
    );
  }

  Widget _buildUserRow(
    BuildContext context, {
    required int rank,
    required String name,
    required int xp,
    required IconData icon,
    required bool isMe,
  }) {
    Color rankColor = Colors.white;
    if (rank == 1)
      rankColor = Colors.yellow;
    else if (rank == 2)
      rankColor = Colors.grey.shade300;
    else if (rank == 3)
      rankColor = Colors.brown.shade300;

    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '#$rank',
              style: TextStyle(
                color: rankColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: isMe ? Colors.blue : Colors.grey.shade800,
            child: Icon(icon, color: Colors.white),
          ),
        ],
      ),
      title: Text(
        name,
        style: TextStyle(
          color: isMe ? Colors.blue.shade200 : Colors.white,
          fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Text(
        '$xp XP',
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
