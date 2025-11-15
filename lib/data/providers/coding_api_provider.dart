// lib/data/providers/coding_api_provider.dart

import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class CodingApiProvider {
  // API çağrıları için HttpClient kullanılır, ancak burada simülasyon yapılıyor
  final http.Client client;

  CodingApiProvider({http.Client? client}) : client = client ?? http.Client();

  /// Kullanıcının Python kodunu çalıştırır ve çıktıyı/hatayı döndürür.
  /// Bu, bir Code Runner API'sine yapılan simüle edilmiş bir çağrıdır.
  ///
  /// Gerçek uygulamada harici bir Python backend'e (örn: Flask/Django + Docker)
  /// POST isteği atacaktır.
  Future<Map<String, dynamic>> runCode(
    String code,
    String expectedOutput,
  ) async {
    // Simülasyon Gecikmesi: Kodun sunucuda çalışması için geçen süreyi taklit eder.
    await Future.delayed(const Duration(seconds: 1));

    // --- Simülasyon Mantığı ---
    if (code.contains(expectedOutput)) {
      return {
        "output": "Kod başarıyla çalıştı ve beklenen çıktıyı verdi.",
        "error": null,
        "is_correct": true,
        "xp_gained": 10, // Başarılıysa 10 XP kazanır
      };
    } else if (code.contains("hata") || code.contains("error")) {
      return {
        "output": "Kodunuzda Python sözdizimi hatası var.",
        "error": "SyntaxError: Eşleşmeyen parantez.",
        "is_correct": false,
        "xp_gained": 0,
      };
    } else {
      return {
        "output": "Beklenen çıktıya ulaşılamadı. Kodun çıktısı farklı.",
        "error":
            "Çıktı uyuşmuyor: Beklenen '$expectedOutput' ancak kod farklı sonuç verdi.",
        "is_correct": false,
        "xp_gained": 0,
      };
    }
    // --- Simülasyon Bitişi ---
  }
}
