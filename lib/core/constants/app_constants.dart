// Uygulama genel sabitleri: renkler, yazı tipleri, API URL'leri gibi değerler
// Bu dosya uygulamanın genelinde kullanılan sabit değerleri merkezi olarak yönetir

class AppConstants {
  // API URL'leri
  static const String baseUrl = 'https://api.kodlingo.com';
  static const String lessonsEndpoint = '/lessons';
  static const String usersEndpoint = '/users';

  // Renk sabitleri
  static const int primaryColor = 0xFF2196F3;
  static const int secondaryColor = 0xFF4CAF50;
  static const int accentColor = 0xFFFF9800;

  // Yazı tipi boyutları
  static const double headlineFontSize = 24.0;
  static const double bodyFontSize = 16.0;
  static const double captionFontSize = 12.0;

  // Diğer sabitler
  static const int maxLives = 5;
  static const int streakBonus = 10;
}
