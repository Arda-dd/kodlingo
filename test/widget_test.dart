// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
// HATA ÇÖZÜMÜ BURADA: 'hide' komutu ile çakışmayı engelliyoruz
import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide ChangeNotifierProvider;

// Eğer pubspec.yaml'da name: loopage yaptıysan, package:loopage/main.dart olabilir.
// Şimdilik kodlingo olarak bıraktığımız için bu doğru:
import 'package:kodlingo/main.dart';
import 'package:kodlingo/domain/notifiers/user_notifier.dart';
import 'package:kodlingo/data/providers/user_local_provider.dart';

void main() {
  testWidgets('Uygulama baslatma testi', (WidgetTester tester) async {
    // 1. Gerekli Provider'ları oluştur (Test ortamı için)
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserNotifier(UserLocalProvider()),
          ),
        ],
        child: const ProviderScope(child: LoopageApp()),
      ),
    );

    // 2. Uygulamanın açıldığını doğrula
    await tester.pump();
  });
}
