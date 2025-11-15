// Provider'lardan veriyi çeken ve Domain'e sunan arayüz - Ders verileri için
// Bu dosya DATA katmanında yer alır ve business logic'ten veri erişimini soyutlar
// DOMAIN katmanındaki usecase'ler bu repository'i kullanır

import '../models/lesson_model.dart';
import '../providers/lesson_api_provider.dart';

abstract class LessonRepository {
  Future<List<LessonModel>> getLessons();
  Future<LessonModel> getLessonById(int id);
  Future<void> updateLessonCompletion(int lessonId, bool isCompleted);
}

class LessonRepositoryImpl implements LessonRepository {
  final LessonApiProvider apiProvider;

  LessonRepositoryImpl({required this.apiProvider});

  @override
  Future<List<LessonModel>> getLessons() async {
    return await apiProvider.getLessons();
  }

  @override
  Future<LessonModel> getLessonById(int id) async {
    return await apiProvider.getLessonById(id);
  }

  @override
  Future<void> updateLessonCompletion(int lessonId, bool isCompleted) async {
    await apiProvider.updateLessonCompletion(lessonId, isCompleted);
  }
}
