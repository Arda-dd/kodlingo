// Uygulamanın iş mantığı için kullanılan temel varlık - Kullanıcı canları
// Bu dosya DOMAIN katmanında yer alır ve business logic'e odaklanır
// Can sistemi: yanlış cevaplar için can kaybı, doğru cevaplar için can kazanma

class CanEntity {
  final int currentCans;
  final int maxCans;
  final DateTime? lastCanRegenerationTime;

  CanEntity({
    required this.currentCans,
    required this.maxCans,
    this.lastCanRegenerationTime,
  });

  // Can kaybı (yanlış cevap)
  CanEntity loseCan() {
    if (currentCans > 0) {
      return CanEntity(
        currentCans: currentCans - 1,
        maxCans: maxCans,
        lastCanRegenerationTime: lastCanRegenerationTime,
      );
    }
    return this; // Can kalmadı
  }

  // Can kazanma (doğru cevap veya ödül)
  CanEntity gainCan() {
    if (currentCans < maxCans) {
      return CanEntity(
        currentCans: currentCans + 1,
        maxCans: maxCans,
        lastCanRegenerationTime: lastCanRegenerationTime,
      );
    }
    return this; // Maksimum can'a ulaşıldı
  }

  // Zamanla can yenilenmesi
  CanEntity regenerateCans() {
    final now = DateTime.now();
    final timeSinceLastRegeneration = lastCanRegenerationTime != null
        ? now.difference(lastCanRegenerationTime!)
        : const Duration(hours: 1); // İlk kez için 1 saat

    // Her 30 dakikada bir can yenilenir
    final regenerationInterval = const Duration(minutes: 30);
    final cansToRegenerate =
        timeSinceLastRegeneration.inMinutes ~/ regenerationInterval.inMinutes;

    if (cansToRegenerate > 0 && currentCans < maxCans) {
      final newCans = (currentCans + cansToRegenerate).clamp(0, maxCans);
      return CanEntity(
        currentCans: newCans,
        maxCans: maxCans,
        lastCanRegenerationTime: now,
      );
    }

    return this;
  }

  // Canların dolu olup olmadığını kontrol
  bool get hasCans => currentCans > 0;

  // Canların maksimumda olup olmadığını kontrol
  bool get isFull => currentCans >= maxCans;
}
