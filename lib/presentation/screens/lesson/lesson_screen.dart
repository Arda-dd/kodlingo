// Çoktan seçmeli ve boşluk doldurma ders ekranı
// Bu dosya PRESENTATION katmanında yer alır ve ders UI'ını yönetir

import 'package:flutter/material.dart';

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

  // Örnek sorular (gerçek uygulamada repository'den gelecek)
  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'multiple_choice',
      'question': 'Python\'da print fonksiyonu ne yapar?',
      'options': [
        'Ekrana yazar',
        'Dosya okur',
        'Değişken tanımlar',
        'Döngü oluşturur',
      ],
      'correct': 'Ekrana yazar',
    },
    {
      'type': 'fill_blank',
      'question': 'Python\'da değişken tanımlamak için ___ kullanılır.',
      'correct': 'print',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Ders ${widget.lessonId}'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${_currentQuestionIndex + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 16),
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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            if (currentQuestion['type'] == 'multiple_choice')
              ..._buildMultipleChoiceOptions(currentQuestion)
            else
              _buildFillBlankInput(),
            const Spacer(),
            Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      child: const Text('Geri'),
                    ),
                  ),
                if (_currentQuestionIndex > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    child: Text(
                      _currentQuestionIndex == _questions.length - 1
                          ? 'Bitir'
                          : 'İleri',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMultipleChoiceOptions(Map<String, dynamic> question) {
    return (question['options'] as List<String>).map((option) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: _selectedAnswer,
          onChanged: (value) {
            setState(() {
              _selectedAnswer = value;
            });
          },
        ),
      );
    }).toList();
  }

  Widget _buildFillBlankInput() {
    return TextField(
      controller: _textController,
      decoration: const InputDecoration(
        hintText: 'Cevabınızı yazın',
        border: OutlineInputBorder(),
      ),
    );
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = null;
        _textController.clear();
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _textController.clear();
      });
    } else {
      // Ders tamamlandı
      _finishLesson();
    }
  }

  void _finishLesson() {
    // Ders tamamlanma işlemi (gelecekte implement edilecek)
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Ders tamamlandı!')));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
