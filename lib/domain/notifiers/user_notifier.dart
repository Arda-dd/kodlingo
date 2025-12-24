// lib/domain/notifiers/user_notifier.dart

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Firestore
import '../../data/models/user_model.dart';
import '../../data/providers/user_local_provider.dart';
import '../entities/can_entity.dart';
import '../entities/streak_entity.dart';

class UserNotifier extends ChangeNotifier {
  final UserLocalProvider _userLocalProvider;

  // Firebase örnekleri
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserNotifier(this._userLocalProvider) {
    _checkCurrentUser(); // Açılışta kullanıcı var mı kontrol et
  }

  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  final List<int> _completedLessonIds = [];

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<int> get completedLessonIds => _completedLessonIds;

  // --- 1. KAYIT OL (Register) ---
  Future<void> register(String email, String password, String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Firebase'de kullanıcı oluştur
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore'a kaydetmek için model oluştur
      UserModel newUser = UserModel(
        id: 1, // Şimdilik sembolik
        username: username,
        email: email,
        xp: 0,
        lives: 5,
        currentStreak: 0,
        lastLoginDate: DateTime.now(),
      );

      // Veritabanına yaz
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'username': username,
        'email': email,
        'xp': 0,
        'lives': 5,
        'currentStreak': 0,
        'lastLoginDate': DateTime.now().toIso8601String(),
      });

      _user = newUser;
      // Yerel telefona da yedekle (Offline için)
      await _userLocalProvider.saveUser(newUser);
    } catch (e) {
      throw Exception('Kayıt başarısız: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- 2. GİRİŞ YAP (Login) ---
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Firebase giriş
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verilerini veritabanından çek
      await _fetchUserData(cred.user!.uid);
    } catch (e) {
      throw Exception('Giriş başarısız: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- 3. VERİ ÇEKME YARDIMCISI ---
  Future<void> _fetchUserData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      _user = UserModel(
        id: 1,
        username: data['username'] ?? 'Kullanıcı',
        email: data['email'] ?? '',
        xp: data['xp'] ?? 0,
        lives: data['lives'] ?? 5,
        currentStreak: data['currentStreak'] ?? 0,
        lastLoginDate: data['lastLoginDate'] != null
            ? DateTime.parse(data['lastLoginDate'])
            : DateTime.now(),
      );

      // Yerel depolamayı güncelle
      await _userLocalProvider.saveUser(_user!);
    }
  }

  // Uygulama açılınca otomatik giriş kontrolü
  Future<void> _checkCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _fetchUserData(currentUser.uid);
    } else {
      await loadUser(); // Giriş yapılmamışsa yerel (misafir) veriyi dene
    }
  }

  // --- MEVCUT FONKSİYONLAR (Aynen korundu) ---
  void completeLesson(int lessonId) {
    if (!_completedLessonIds.contains(lessonId)) {
      _completedLessonIds.add(lessonId);
      notifyListeners();
    }
  }

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _userLocalProvider.getUser();
      // Eğer kullanıcı yoksa boş bırak, Login ekranına yönlensin
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserData(
      {required bool isCorrectAnswer, int xpChange = 0}) async {
    if (_user == null) return;

    // Can ve XP mantığı
    CanEntity currentCan = CanEntity(currentCans: _user!.lives, maxCans: 5);
    if (!isCorrectAnswer) currentCan = currentCan.loseCan();

    int newXp = _user!.xp + xpChange;

    final updatedUser = _user!.copyWith(
      xp: newXp,
      lives: currentCan.currentCans,
      lastLoginDate: DateTime.now(),
    );

    _user = updatedUser;

    // Hem yerele hem Firebase'e kaydet
    await _userLocalProvider.saveUser(updatedUser);

    if (_auth.currentUser != null) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'xp': newXp,
        'lives': currentCan.currentCans,
        'lastLoginDate': DateTime.now().toIso8601String(),
      });
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _userLocalProvider.clearUser();
    _user = null;
    notifyListeners();
  }
}
