import 'package:flutter/material.dart';
import '../../../core/routes/app_router.dart';
import '../../widgets/common/custom_button.dart';

class LessonSuccessScreen extends StatelessWidget {
  final int earnedXp;

  const LessonSuccessScreen({super.key, required this.earnedXp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Başarı Görseli / İkonu
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  size: 100,
                  color: Colors.yellow.shade700,
                ),
              ),
              const SizedBox(height: 32),

              // Başlık
              Text(
                'Tebrikler!',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Açıklama
              Text(
                'Dersi başarıyla tamamladın.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Kazanılan XP Kartı
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'TOPLAM KAZANÇ',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          '+$earnedXp XP',
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Devam Et Butonu
              CustomButton(
                text: 'DEVAM ET',
                onPressed: () {
                  // Ana sayfaya dön ve geriye dönük tüm sayfaları temizle
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
                },
                backgroundColor: Colors.green.shade600,
                height: 56,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
