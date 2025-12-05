// lib/data/models/user_model.dart

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

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    int? xp,
    int? lives,
    int? currentStreak,
    DateTime? lastLoginDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      xp: xp ?? this.xp,
      lives: lives ?? this.lives,
      currentStreak: currentStreak ?? this.currentStreak,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
    );
  }

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

  // --- YENİ EKLENEN LİG SİSTEMİ MANTIĞI ---

  // XP'ye göre Lig Adı
  String get currentLeague {
    if (xp <= 200) return 'Hello World Ligi';
    if (xp <= 500) return 'Bug Hunter Ligi';
    if (xp <= 1000) return 'Script Kiddie Ligi';
    if (xp <= 2000) return 'Junior Dev Ligi';
    if (xp <= 4000) return 'Senior Dev Ligi';
    return 'Architect Ligi';
  }

  // Bir sonraki lige kalan XP
  int get xpToNextLeague {
    if (xp <= 200) return 201 - xp;
    if (xp <= 500) return 501 - xp;
    if (xp <= 1000) return 1001 - xp;
    if (xp <= 2000) return 2001 - xp;
    if (xp <= 4000) return 4001 - xp;
    return 0; // Zirve
  }
}
