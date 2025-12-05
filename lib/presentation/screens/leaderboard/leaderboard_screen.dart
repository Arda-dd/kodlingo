// lib/presentation/screens/leaderboard/leaderboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/notifiers/user_notifier.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  // Lig Özelliklerini Belirleyen Yardımcı Fonksiyon
  Map<String, dynamic> _getLeagueStyles(String leagueName) {
    switch (leagueName) {
      case 'Hello World Ligi':
        return {'color': Colors.green, 'icon': Icons.eco};
      case 'Bug Hunter Ligi':
        return {'color': Colors.amber, 'icon': Icons.bug_report};
      case 'Script Kiddie Ligi':
        return {'color': Colors.orange, 'icon': Icons.terminal};
      case 'Junior Dev Ligi':
        return {'color': Colors.blue, 'icon': Icons.laptop_mac};
      case 'Senior Dev Ligi':
        return {'color': Colors.red, 'icon': Icons.local_fire_department};
      case 'Architect Ligi':
        return {'color': Colors.deepPurple, 'icon': Icons.architecture};
      default:
        return {'color': Colors.grey, 'icon': Icons.help};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (context, userNotifier, _) {
        final user = userNotifier.user;

        // Kullanıcı henüz yüklenmediyse boş göster
        if (user == null) return const SizedBox();

        // Kullanıcının lig bilgilerini al
        final leagueName = user.currentLeague;
        final leagueStyles = _getLeagueStyles(leagueName);
        final Color leagueColor = leagueStyles['color'];
        final IconData leagueIcon = leagueStyles['icon'];

        // Sahte Veriler (Kullanıcının puanına göre dinamik oluşur)
        final List<Map<String, dynamic>> fakeUsers = [
          {'name': 'Kod Canavarı', 'xp': user.xp + 150, 'avatar': Icons.person},
          {
            'name': 'Python Ustası',
            'xp': user.xp + 50,
            'avatar': Icons.emoji_events,
          },
          // Bizim kullanıcı index 2'de olacak (Araya sıkıştıracağız)
          {
            'name': 'Dart Sever',
            'xp': (user.xp - 50).clamp(0, 99999),
            'avatar': Icons.code,
          },
          {
            'name': 'Flutter Fan',
            'xp': (user.xp - 120).clamp(0, 99999),
            'avatar': Icons.phone_android,
          },
        ];

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              // --- LİG BAŞLIK KARTI (YENİ TASARIM) ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      leagueColor.withOpacity(0.8),
                      leagueColor.withOpacity(0.3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(leagueIcon, size: 64, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      leagueName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (user.xpToNextLeague > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Sonraki lige ${user.xpToNextLeague} XP kaldı',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      )
                    else
                      const Text(
                        'Zirvedesin! 👑',
                        style: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(left: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'BU HAFTANIN SIRALAMASI',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // --- SIRALAMA LİSTESİ ---
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: fakeUsers.length + 1,
                  itemBuilder: (context, index) {
                    // Kullanıcıyı 3. sıraya yerleştir
                    if (index == 2) {
                      return _buildCurrentUserRow(
                        context,
                        user.xp,
                        user.username,
                        leagueColor,
                      );
                    }

                    final userIndex = index > 2 ? index - 1 : index;
                    final fakeUser = fakeUsers[userIndex];

                    return _buildUserRow(
                      context,
                      rank: index + 1,
                      name: fakeUser['name'],
                      xp: fakeUser['xp'],
                      icon: fakeUser['avatar'],
                      isMe: false,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentUserRow(
    BuildContext context,
    int xp,
    String name,
    Color glowColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: glowColor.withOpacity(0.15),
        border: Border.symmetric(
          horizontal: BorderSide(color: glowColor.withOpacity(0.5), width: 1),
        ),
      ),
      child: _buildUserRow(
        context,
        rank: 3,
        name: '$name (Sen)',
        xp: xp,
        icon: Icons.account_circle,
        isMe: true,
        highlightColor: glowColor,
      ),
    );
  }

  Widget _buildUserRow(
    BuildContext context, {
    required int rank,
    required String name,
    required int xp,
    required IconData icon,
    required bool isMe,
    Color? highlightColor,
  }) {
    Color rankColor = Colors.white;
    if (rank == 1)
      rankColor = const Color(0xFFFFD700); // Altın
    else if (rank == 2)
      rankColor = const Color(0xFFC0C0C0); // Gümüş
    else if (rank == 3)
      rankColor = const Color(0xFFCD7F32); // Bronz

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$rank',
              style: TextStyle(
                color: rankColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundColor: isMe
                ? (highlightColor ?? Colors.blue)
                : Colors.grey.shade800,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ],
      ),
      title: Text(
        name,
        style: TextStyle(
          color: isMe ? (highlightColor ?? Colors.blue.shade200) : Colors.white,
          fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
      trailing: Text(
        '$xp XP',
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
