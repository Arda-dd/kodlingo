// Yerel depolama servisleri - Kullanıcı verileri için
// Bu dosya DATA katmanında yer alır ve cihazda yerel veri saklama işlemlerini yönetir
// SharedPreferences veya benzeri yerel depolama çözümlerini kullanır

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserLocalProvider {
  static const String _userKey = 'user_data';

  // Kullanıcı verilerini yerel depodan getirme
  Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }

      return null;
    } catch (e) {
      throw Exception('Yerel veri okuma hatası: $e');
    }
  }

  // Kullanıcı verilerini yerel depoya kaydetme
  Future<void> saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(user.toJson());
      await prefs.setString(_userKey, userJson);
    } catch (e) {
      throw Exception('Yerel veri kaydetme hatası: $e');
    }
  }

  // Kullanıcı verilerini temizleme (çıkış yapma)
  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      throw Exception('Yerel veri temizleme hatası: $e');
    }
  }

  // Kullanıcı XP'sini güncelleme
  Future<void> updateUserXp(int newXp) async {
    try {
      final user = await getUser();
      if (user != null) {
        final updatedUser = UserModel(
          id: user.id,
          username: user.username,
          email: user.email,
          xp: newXp,
          lives: user.lives,
          currentStreak: user.currentStreak,
          lastLoginDate: user.lastLoginDate,
        );
        await saveUser(updatedUser);
      }
    } catch (e) {
      throw Exception('XP güncelleme hatası: $e');
    }
  }
}
