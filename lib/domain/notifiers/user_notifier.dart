// State Management - Kullanıcı verileri için durum yöneticisi
// Bu dosya DOMAIN katmanında yer alır ve UI state'ini yönetir
// Basit state management için ChangeNotifier kullanarak

import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/user_local_provider.dart';

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

  // Kullanıcı verilerini yükleme
  Future<void> loadUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _userLocalProvider.getUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  // Kullanıcı XP'sini güncelleme
  Future<void> updateUserXp(int newXp) async {
    if (_user != null) {
      try {
        await _userLocalProvider.updateUserXp(newXp);
        _user = UserModel(
          id: _user!.id,
          username: _user!.username,
          email: _user!.email,
          xp: newXp,
          lives: _user!.lives,
          currentStreak: _user!.currentStreak,
          lastLoginDate: _user!.lastLoginDate,
        );
        notifyListeners();
      } catch (e) {
        _error = e.toString();
        notifyListeners();
      }
    }
  }

  // Kullanıcı çıkış yapma
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
