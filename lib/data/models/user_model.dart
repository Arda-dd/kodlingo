// API'den gelen veya DB'ye kaydedilen User veri modeli
// Bu dosya DATA katmanında yer alır ve harici veri kaynaklarından gelen veriyi temsil eder
// DOMAIN katmanındaki entity'lerden farklı olarak, API/DB yapısına bağlıdır

class UserModel {
  final int id;
  final String username;
  final String email;
  final int xp;
  final int lives;
  final int currentStreak;
  final DateTime? lastLoginDate;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.xp,
    required this.lives,
    required this.currentStreak,
    this.lastLoginDate,
  });

  // JSON'dan UserModel oluşturma (API response için)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      xp: json['xp'] as int,
      lives: json['lives'] as int,
      currentStreak: json['current_streak'] as int,
      lastLoginDate: json['last_login_date'] != null
          ? DateTime.parse(json['last_login_date'] as String)
          : null,
    );
  }

  // UserModel'dan JSON'a dönüştürme (API request için)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'xp': xp,
      'lives': lives,
      'current_streak': currentStreak,
      'last_login_date': lastLoginDate?.toIso8601String(),
    };
  }
}
