// lib/domain/notifiers/user_notifier.dart

import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/user_local_provider.dart';
import '../entities/can_entity.dart';
import '../entities/streak_entity.dart';

class UserNotifier extends ChangeNotifier {
  final UserLocalProvider _userLocalProvider;

  UserNotifier(this._userLocalProvider) {
    loadUser();
  }

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Kullanıcı verilerini yükleme ve başlangıç değerlerini ayarlama
  Future<void> loadUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _userLocalProvider.getUser();

      if (_user == null) {
        _user = UserModel(
          id: 1,
          username: 'KodLingo Öğrencisi',
          email: 'user@kodlingo.com',
          xp: 0,
          lives: 5,
          currentStreak: 0,
          lastLoginDate: DateTime.now().subtract(
            const Duration(days: 1),
          ), // İlk aktiviteyi tetikler
        );
        await saveUser(_user!);
      }
      _checkGameStatus(); // Can ve Seri kontrolü
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Can yenilenmesi ve seri sıfırlanmasını kontrol eder
  void _checkGameStatus() {
    if (_user == null) return;

    // Can Kontrolü
    var canEntity = CanEntity(
      currentCans: _user!.lives,
      maxCans: 5,
      lastCanRegenerationTime: _user!.lastLoginDate,
    ).regenerateCans();

    // Dün aktivite yapılmadıysa seriyi sıfırla (2 günden fazla zaman geçtiyse)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_user!.lastLoginDate != null) {
      final lastActivityDay = DateTime(
        _user!.lastLoginDate!.year,
        _user!.lastLoginDate!.month,
        _user!.lastLoginDate!.day,
      );
      final twoDaysAgo = today.subtract(const Duration(days: 2));

      if (lastActivityDay.isBefore(twoDaysAgo)) {
        // Seri kırıldı
        final updatedUser = _user!.copyWith(
          lives: canEntity.currentCans,
          currentStreak: 0,
          // lastLoginDate güncellenmez, saveUser'da güncellenir.
        );
        saveUser(updatedUser);
        return;
      }
    }

    // Sadece Can güncellenmesi gerekiyorsa güncelle
    if (canEntity.currentCans != _user!.lives) {
      final updatedUser = _user!.copyWith(lives: canEntity.currentCans);
      saveUser(updatedUser);
    }
  }

  // Kullanıcı XP, Can ve Seri verilerini tek bir işlemle güncelleme
  Future<void> updateUserData({
    required bool isCorrectAnswer,
    int xpChange = 0,
  }) async {
    if (_user == null) return;

    // 1. Can Mantığı (Yanlışsa 1 Can kaybeder)
    CanEntity currentCan = CanEntity(currentCans: _user!.lives, maxCans: 5);
    if (!isCorrectAnswer) {
      currentCan = currentCan.loseCan();
    }

    // 2. XP ve Seri Mantığı
    int newXp = _user!.xp + xpChange;

    // Seri, doğru cevapta kontrol edilir
    StreakEntity currentStreak = StreakEntity(
      currentStreak: _user!.currentStreak,
      longestStreak: _user!.currentStreak,
      lastActivityDate: _user!.lastLoginDate,
      isActiveToday: false,
    );

    if (isCorrectAnswer) {
      currentStreak = currentStreak.updateStreak();
    }

    // Yeni UserModel oluştur
    final updatedUser = _user!.copyWith(
      xp: newXp,
      lives: currentCan.currentCans,
      currentStreak: currentStreak.currentStreak,
      lastLoginDate: DateTime.now(), // Son aktivite zamanını güncelle
    );

    await saveUser(updatedUser);
  }

  // Kullanıcı verilerini kaydetme
  Future<void> saveUser(UserModel user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _userLocalProvider.saveUser(user);
      _user = user;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Kullanıcı çıkış yapma (Basitlik için sadece temizleme işlemi)
  Future<void> logout() async {
    try {
      await _userLocalProvider.clearUser();
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
