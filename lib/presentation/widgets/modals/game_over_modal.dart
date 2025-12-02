import 'package:flutter/material.dart';
import '../../../core/routes/app_router.dart';
import '../common/custom_button.dart';

class GameOverModal extends StatelessWidget {
  const GameOverModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Theme.of(context).colorScheme.surface, // Koyu tema rengi
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // İçerik kadar yer kapla
          children: [
            // Kalp Kırık İkonu
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.heart_broken_rounded,
                size: 64,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),

            // Başlık
            Text(
              'Canın Kalmadı!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Açıklama Mesajı
            Text(
              'Üzgünüz, tüm canlarını kullandın. Devam etmek için reklam izleyebilir veya canlarının yenilenmesini bekleyebilirsin.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Buton 1: Reklam İzle (Öncelikli Aksiyon)
            CustomButton(
              text: 'Reklam İzle (+1 Can)',
              backgroundColor: Colors.green.shade600,
              onPressed: () {
                Navigator.of(context).pop(); // Modalı kapat
                // İleride buraya reklam izleme kodu gelecek
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reklam izleme modülü yakında eklenecek!'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Buton 2: Ana Sayfaya Dön (İkincil Aksiyon)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  // Ana sayfaya dön ve tüm geçmişi temizle
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Ana Sayfaya Dön',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
