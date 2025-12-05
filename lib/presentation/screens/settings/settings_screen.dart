import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Şimdilik ayarları sadece bu ekran içinde tutuyoruz (State)
  // İleride bunları da kalıcı hale getirebiliriz.
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader('GENEL'),

          SwitchListTile(
            activeColor: Colors.green,
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            title: const Text(
              'Bildirimler',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Günlük hatırlatıcılar al',
              style: TextStyle(color: Colors.grey),
            ),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.notifications, color: Colors.blue),
            ),
          ),

          SwitchListTile(
            activeColor: Colors.green,
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            title: const Text(
              'Ses Efektleri',
              style: TextStyle(color: Colors.white),
            ),
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
              });
            },
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.volume_up, color: Colors.purple),
            ),
          ),

          const Divider(color: Colors.white10, height: 32),
          _buildSectionHeader('GÖRÜNÜM'),

          SwitchListTile(
            activeColor: Colors.green,
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            title: const Text(
              'Karanlık Mod',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Göz yormayan tema',
              style: TextStyle(color: Colors.grey),
            ),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              // Şimdilik sadece görsel, tema değişimi için main.dart'ta yapı değişikliği gerekir
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tema şu an sabit Karanlık Mod\'dur.'),
                ),
              );
            },
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.dark_mode, color: Colors.orange),
            ),
          ),

          const Divider(color: Colors.white10, height: 32),
          _buildSectionHeader('UYGULAMA'),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.language, color: Colors.green),
            ),
            title: const Text(
              'Dil / Language',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Türkçe',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white54,
            ),
            onTap: () {},
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info_outline, color: Colors.grey),
            ),
            title: const Text(
              'Hakkında',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'v1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
