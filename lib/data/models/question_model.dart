// API'den gelen veya DB'ye kaydedilen Question veri modeli
// Bu dosya DATA katmanında yer alır ve soru verilerini temsil eder

class QuestionModel {
  final int id;
  final String question;
  final List<String> options; // Çoktan seçmeli için
  final String correctAnswer;
  final String? hint;
  final String type; // 'multiple_choice', 'fill_blank'

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.hint,
    required this.type,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as int,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>?)?.cast<String>() ?? [],
      correctAnswer: json['correct_answer'] as String,
      hint: json['hint'] as String?,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
      'hint': hint,
      'type': type,
    };
  }
}
