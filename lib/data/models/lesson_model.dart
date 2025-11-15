// API'den gelen veya DB'ye kaydedilen Lesson veri modeli
// Bu dosya DATA katmanında yer alır ve ders verilerini temsil eder

class LessonModel {
  final int id;
  final String title;
  final String description;
  final String content;
  final String type; // 'multiple_choice', 'fill_blank', 'coding'
  final List<QuestionModel> questions;
  final int xpReward;
  final bool isCompleted;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.type,
    required this.questions,
    required this.xpReward,
    required this.isCompleted,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
      xpReward: json['xp_reward'] as int,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'type': type,
      'questions': questions.map((q) => q.toJson()).toList(),
      'xp_reward': xpReward,
      'is_completed': isCompleted,
    };
  }
}
