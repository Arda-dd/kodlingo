// lib/data/repositories/mock_lesson_data.dart
import '../models/lesson_model.dart';
import '../models/question_model.dart';

class MockLessonData {
  // Örnek Soru Model
  static final List<QuestionModel> sampleQuestions = [
    QuestionModel(
      id: 1,
      question: "Python'da bir metin değişkeni nasıl tanımlanır?",
      options: [
        'metin = "merhaba"',
        'metin: "merhaba"',
        'var metin = "merhaba"',
      ],
      correctAnswer: 'metin = "merhaba"',
      type: 'multiple_choice',
    ),
  ];

  static final List<LessonModel> lessons = [
    LessonModel(
      id: 1,
      title: 'Modül 1: Merhaba Dünya!',
      description: 'İlk kodunuzu yazın ve Python ortamını tanıyın.',
      content: 'Temel print() fonksiyonu.',
      type: 'fill_blank',
      questions: sampleQuestions,
      xpReward: 15,
      isCompleted: false, // <<< BURAYI "false" YAPTIK
    ),
    LessonModel(
      id: 2,
      title: 'Modül 2: Değişken Tanımlama',
      description: 'Sayılar, metinler ve boolean tiplerini öğrenin.',
      content: 'Değişken atama kuralları.',
      type: 'coding',
      questions: [],
      xpReward: 25,
      isCompleted: false,
    ),
    // ... (Diğer dersler aynı kalıyor: id 3, 4, 5 hepsi false olmalı) ...
    LessonModel(
      id: 3,
      title: 'Modül 3: Koşullu İfadeler (if/else)',
      description: 'Programınızın karar vermesini sağlayın.',
      content: 'if, elif, else blokları.',
      type: 'coding',
      questions: [],
      xpReward: 30,
      isCompleted: false,
    ),
    LessonModel(
      id: 4,
      title: 'Modül 4: Döngüler',
      description: 'For ve While döngüleri ile tekrarlı işleri otomatize edin.',
      content: 'range() fonksiyonu ve döngü kullanımı.',
      type: 'coding',
      questions: [],
      xpReward: 40,
      isCompleted: false,
    ),
    LessonModel(
      id: 5,
      title: 'Modül 5: Fonksiyon Oluşturma',
      description: 'Kodunuzu küçük, tekrar kullanılabilir parçalara ayırın.',
      content: 'def anahtar kelimesi ve parametreler.',
      type: 'coding',
      questions: [],
      xpReward: 50,
      isCompleted: false,
    ),
  ];

  // ... (completeLesson fonksiyonu aynı kalıyor) ...
  static void completeLesson(int id) {
    final index = lessons.indexWhere((element) => element.id == id);
    if (index != -1) {
      final oldLesson = lessons[index];
      lessons[index] = LessonModel(
        id: oldLesson.id,
        title: oldLesson.title,
        description: oldLesson.description,
        content: oldLesson.content,
        type: oldLesson.type,
        questions: oldLesson.questions,
        xpReward: oldLesson.xpReward,
        isCompleted: true,
      );
    }
  }
}
