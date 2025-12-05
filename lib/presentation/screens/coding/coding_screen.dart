// lib/presentation/screens/coding/coding_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/modals/game_over_modal.dart';
import '../../../data/providers/coding_api_provider.dart';
import '../../../domain/notifiers/user_notifier.dart';
import '../../widgets/common/custom_button.dart';
import '../../../core/routes/app_router.dart';
// Mock veriyi çekmek için gerekli import
import '../../../data/repositories/mock_lesson_data.dart';

class CodingScreen extends StatefulWidget {
  final int lessonId;

  const CodingScreen({super.key, required this.lessonId});

  @override
  State<CodingScreen> createState() => _CodingScreenState();
}

class _CodingScreenState extends State<CodingScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _output = 'Kodu çalıştırın ve çıktıyı burada görün.';
  bool _isRunning = false;
  bool _isSuccess = false;
  int _xpGained = 0;

  final String _initialCode = '''# Python kodunuzu buraya yazın
print("Merhaba KodLingo")''';
  final String _expectedOutput = 'Merhaba KodLingo';

  @override
  void initState() {
    super.initState();
    _codeController.text = _initialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kod Editörü - Ders ${widget.lessonId}')),
      body: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              text: _isRunning ? 'Çalıştırılıyor...' : 'Kodu Çalıştır',
              onPressed: _isRunning ? null : _runCode,
              isLoading: _isRunning,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                border: Border.all(
                  color: _isSuccess
                      ? Colors.green.shade300
                      : Colors.red.shade300,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _output,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: _isSuccess
                        ? Colors.green.shade800
                        : Colors.red.shade800,
                  ),
                ),
              ),
            ),
          ),
          if (_isSuccess)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Başarılı! +$_xpGained XP kazandınız.',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _runCode() async {
    if (_isRunning) return;

    if (Provider.of<UserNotifier>(context, listen: false).user?.lives == 0) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const GameOverModal(),
        );
      }
      return;
    }

    setState(() {
      _isRunning = true;
      _output = 'Kod çalıştırılıyor...\n';
      _isSuccess = false;
      _xpGained = 0;
    });

    final userNotifier = Provider.of<UserNotifier>(context, listen: false);
    final codingApiProvider = CodingApiProvider();

    try {
      final result = await codingApiProvider.runCode(
        _codeController.text,
        _expectedOutput,
      );

      if (result['is_correct'] == true) {
        // --- DÜZELTME BURADA ---
        // API'den gelen sahte 10 puan yerine, dersin gerçek ödülünü alıyoruz.
        final currentLesson = MockLessonData.lessons.firstWhere(
          (l) => l.id == widget.lessonId,
        );
        final lessonXp = currentLesson.xpReward;

        setState(() {
          _output = 'Çıktı:\n${result['output']}';
          _isSuccess = true;
          _xpGained = lessonXp; // Doğru puanı ata (25, 30, 50 vb.)
        });

        await userNotifier.updateUserData(
          isCorrectAnswer: true,
          xpChange: _xpGained,
        );

        if (mounted) _finishLesson(true);
      } else {
        setState(() {
          _output = 'Hata:\n${result['error'] ?? result['output']}';
          _isSuccess = false;
          _xpGained = 0;
        });

        await userNotifier.updateUserData(isCorrectAnswer: false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Hatalı kod! 1 Can kaybettiniz.')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _output = 'Bağlantı/Sunucu Hatası: $e';
        _isSuccess = false;
      });
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _finishLesson(bool success) {
    if (success) {
      Provider.of<UserNotifier>(
        context,
        listen: false,
      ).completeLesson(widget.lessonId);

      Navigator.of(context).pushReplacementNamed(
        AppRouter.lessonSuccess,
        arguments: {'earnedXp': _xpGained},
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
