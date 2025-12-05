// lib/presentation/screens/lesson/lesson_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/notifiers/user_notifier.dart';
import '../../widgets/modals/game_over_modal.dart';
// Mock veriyi çekmek için import
import '../../../data/repositories/mock_lesson_data.dart';

class LessonScreen extends StatefulWidget {
  final int lessonId;

  const LessonScreen({super.key, required this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  final TextEditingController _textController = TextEditingController();

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'multiple_choice',
      'question':
          'Python\'da ekrana yazı yazdırmak için hangi fonksiyon kullanılır?',
      'options': ['print()', 'echo()', 'console.log()', 'write()'],
      'correct': 'print()',
    },
    {
      'type': 'fill_blank',
      'question':
          'Değişken tanımlamak için eşittir (=) işareti kullanılır. Örn: x ___ 5',
      'correct': '=',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final isLastQuestion = _currentQuestionIndex == _questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ders ${widget.lessonId}'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${_currentQuestionIndex + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion['question'],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: currentQuestion['type'] == 'multiple_choice'
                    ? _buildMultipleChoiceOptions(currentQuestion)
                    : _buildFillBlankInput(),
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: _checkAnswer,
                child: Text(
                  isLastQuestion ? 'BİTİR' : 'KONTROL ET',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleChoiceOptions(Map<String, dynamic> question) {
    return Column(
      children: (question['options'] as List<String>).map((option) {
        final isSelected = _selectedAnswer == option;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedAnswer = option;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.withOpacity(0.2)
                    : Theme.of(context).cardColor,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade700,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: Colors.blue),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFillBlankInput() {
    return TextField(
      controller: _textController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Cevabınızı buraya yazın...',
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  void _checkAnswer() {
    final currentQuestion = _questions[_currentQuestionIndex];
    bool isCorrect = false;

    if (currentQuestion['type'] == 'multiple_choice') {
      if (_selectedAnswer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir seçenek işaretleyin.')),
        );
        return;
      }
      isCorrect = _selectedAnswer == currentQuestion['correct'];
    } else {
      if (_textController.text.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Lütfen cevabı yazın.')));
        return;
      }
      isCorrect =
          _textController.text.trim().toLowerCase() ==
          currentQuestion['correct'].toString().toLowerCase();
    }

    final userNotifier = Provider.of<UserNotifier>(context, listen: false);

    if (isCorrect) {
      // --- DÜZELTME: Soru başına 5 XP vermiyoruz, ödülü sona saklıyoruz ---
      // Sadece 'doğru cevap' olduğunu işleyerek seriyi (streak) koruyoruz ama XP'yi 0 geçiyoruz.
      userNotifier.updateUserData(isCorrectAnswer: true, xpChange: 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Harika! Doğru cevap.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) _goToNextQuestion();
      });
    } else {
      userNotifier.updateUserData(isCorrectAnswer: false);

      if (userNotifier.user != null && userNotifier.user!.lives <= 0) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const GameOverModal(),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Yanlış cevap! 1 Can kaybettin.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _textController.clear();
      });
    } else {
      _finishLesson();
    }
  }

  void _finishLesson() {
    // --- DÜZELTME BURADA ---
    // Dersin gerçek ödülünü çekiyoruz
    final currentLesson = MockLessonData.lessons.firstWhere(
      (l) => l.id == widget.lessonId,
      // Hata önlemek için varsayılan bir ders döndürelim (opsiyonel güvenlik)
      orElse: () => MockLessonData.lessons[0],
    );

    final lessonXp = currentLesson.xpReward;

    // Puanı burada topluca veriyoruz
    Provider.of<UserNotifier>(
      context,
      listen: false,
    ).updateUserData(isCorrectAnswer: true, xpChange: lessonXp);

    // Tamamlandı olarak işaretle
    Provider.of<UserNotifier>(
      context,
      listen: false,
    ).completeLesson(widget.lessonId);

    // Ekrana doğru puanı gönder
    Navigator.of(context).pushReplacementNamed(
      AppRouter.lessonSuccess,
      arguments: {'earnedXp': lessonXp},
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
