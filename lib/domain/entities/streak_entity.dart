// Uygulamanın iş mantığı için kullanılan temel varlık - Kullanıcı serileri
// Bu dosya DOMAIN katmanında yer alır ve business logic'e odaklanır
// DATA katmanındaki modellere bağımlı değildir, saf business entity'dir

class StreakEntity {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final bool isActiveToday;

  StreakEntity({
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
    required this.isActiveToday,
  });

  // Seriyi güncelleme (aktivite sonrası)
  StreakEntity updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastActivityDate != null) {
      final lastActivityDay = DateTime(
        lastActivityDate!.year,
        lastActivityDate!.month,
        lastActivityDate!.day,
      );

      if (lastActivityDay == today) {
        // Bugün zaten aktivite yapıldı
        return this;
      } else if (lastActivityDay == today.subtract(const Duration(days: 1))) {
        // Dün aktivite yapıldı, seri devam ediyor
        final newStreak = currentStreak + 1;
        return StreakEntity(
          currentStreak: newStreak,
          longestStreak: newStreak > longestStreak ? newStreak : longestStreak,
          lastActivityDate: now,
          isActiveToday: true,
        );
      } else {
        // Seri kırıldı
        return StreakEntity(
          currentStreak: 1,
          longestStreak: longestStreak,
          lastActivityDate: now,
          isActiveToday: true,
        );
      }
    } else {
      // İlk aktivite
      return StreakEntity(
        currentStreak: 1,
        longestStreak: 1,
        lastActivityDate: now,
        isActiveToday: true,
      );
    }
  }

  // Seriyi sıfırlama
  StreakEntity resetStreak() {
    return StreakEntity(
      currentStreak: 0,
      longestStreak: longestStreak,
      lastActivityDate: null,
      isActiveToday: false,
    );
  }
}
