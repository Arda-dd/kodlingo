// Belirli iş akışlarını temsil eden fonksiyon - Seri güncelleme
// Bu dosya DOMAIN katmanında yer alır ve business logic'i kapsüller
// Repository'leri kullanarak veri işlemlerini yönetir

import '../entities/streak_entity.dart';
// import '../repositories/streak_repository.dart'; // Gelecekte oluşturulacak

class UpdateStreakUsecase {
  // final StreakRepository streakRepository; // Dependency injection ile gelecek

  // Constructor - repository injection
  // UpdateStreakUsecase({required this.streakRepository});

  // Seriyi güncelleme iş akışı
  Future<StreakEntity> execute(StreakEntity currentStreak) async {
    try {
      // Business logic: aktivite sonrası seriyi güncelle
      final updatedStreak = currentStreak.updateStreak();

      // Repository ile veri tabanına kaydetme (gelecekte)
      // await streakRepository.saveStreak(updatedStreak);

      return updatedStreak;
    } catch (e) {
      throw Exception('Seri güncellenirken hata oluştu: $e');
    }
  }

  // Seriyi sıfırlama iş akışı
  Future<StreakEntity> resetStreak(StreakEntity currentStreak) async {
    try {
      final resetStreak = currentStreak.resetStreak();

      // Repository ile veri tabanına kaydetme (gelecekte)
      // await streakRepository.saveStreak(resetStreak);

      return resetStreak;
    } catch (e) {
      throw Exception('Seri sıfırlanırken hata oluştu: $e');
    }
  }

  // Seri bilgilerini getirme iş akışı
  Future<StreakEntity> getCurrentStreak() async {
    try {
      // Repository'den mevcut seriyi getirme (gelecekte)
      // return await streakRepository.getCurrentStreak();

      // Şimdilik varsayılan değer döndür
      return StreakEntity(
        currentStreak: 0,
        longestStreak: 0,
        lastActivityDate: null,
        isActiveToday: false,
      );
    } catch (e) {
      throw Exception('Seri bilgileri alınırken hata oluştu: $e');
    }
  }
}
