// Kod yazma editörü ve sonuç ekranı
// Bu dosya PRESENTATION katmanında yer alır ve kod editörü UI'ını yönetir
// Veri gönderme/alma için data/providers katmanındaki bir servisi kullanır

import 'package:flutter/material.dart';
import '../../widgets/common/custom_button.dart';

class CodingScreen extends StatefulWidget {
  final int lessonId;

  const CodingScreen({super.key, required this.lessonId});

  @override
  State<CodingScreen> createState() => _CodingScreenState();
}

class _CodingScreenState extends State<CodingScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _output = '';
  bool _isRunning = false;

  // Örnek kod şablonu
  final String _initialCode = '''# Python kodunuzu buraya yazın
print("Merhaba Dünya!")

# Örnek: Değişken tanımlama
isim = "KodLingo"
print("Merhaba", isim)''';

  @override
  void initState() {
    super.initState();
    _codeController.text = _initialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kod Editörü - Ders ${widget.lessonId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _isRunning ? null : _runCode,
            tooltip: 'Kodu Çalıştır',
          ),
        ],
      ),
      body: Column(
        children: [
          // Kod editörü
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _codeController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'Python kodunuzu buraya yazın...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
              ),
            ),
          ),
          // Çalıştır butonu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              text: _isRunning ? 'Çalıştırılıyor...' : 'Kodu Çalıştır',
              onPressed: _isRunning ? null : _runCode,
              isLoading: _isRunning,
            ),
          ),
          const SizedBox(height: 16),
          // Çıktı alanı
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _output.isEmpty ? 'Çıktı burada görünecek...' : _output,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Kodu çalıştırma işlemi - data/providers servisini kullanır
  Future<void> _runCode() async {
    setState(() {
      _isRunning = true;
      _output = 'Kod çalıştırılıyor...\n';
    });

    try {
      // Burada data/providers katmanındaki servis kullanılacak
      // Örnek: CodingApiProvider.runCode(_codeController.text)

      // Şimdilik simülasyon
      await Future.delayed(const Duration(seconds: 2));

      // Örnek çıktı (gerçek uygulamada API'den gelecek)
      final code = _codeController.text;
      String result = '';

      if (code.contains('print(')) {
        result =
            'Kod başarıyla çalıştırıldı!\n\nÇıktı:\nMerhaba Dünya!\nMerhaba KodLingo';
      } else {
        result = 'Kod çalıştırıldı ama print ifadesi bulunamadı.';
      }

      setState(() {
        _output = result;
      });

      // Başarılı olursa snackbar göster
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kod başarıyla çalıştırıldı!')),
      );
    } catch (e) {
      setState(() {
        _output = 'Hata: $e';
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kod çalıştırılırken hata: $e')));
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
