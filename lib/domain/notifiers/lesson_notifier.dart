// lib/domain/notifiers/lesson_notifier.dart
// State Management - Ders verileri için durum yöneticisi

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/providers/lesson_api_provider.dart';
import '../../data/repositories/lesson_repository.dart'; // <<< EKLENDİ: LessonRepository ve LessonRepositoryImpl için
import '../../data/models/lesson_model.dart';

// Lesson repository provider (dependency injection için)
final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  // LessonRepositoryImpl sınıfını kullanarak LessonApiProvider ile somut bir implementasyon oluşturulur.
  final apiProvider = LessonApiProvider(client: http.Client());
  return LessonRepositoryImpl(apiProvider: apiProvider);
});

// Lesson notifier - ders listesi için state management
class LessonNotifier extends StateNotifier<AsyncValue<List<LessonModel>>> {
  final LessonRepository _lessonRepository;

  LessonNotifier(this._lessonRepository) : super(const AsyncValue.loading()) {
    loadLessons();
  }

  // Dersleri yükleme
  Future<void> loadLessons() async {
    state = const AsyncValue.loading();
    try {
      final lessons = await _lessonRepository.getLessons();
      state = AsyncValue.data(lessons);
    } catch (e, stackTrace) {
      // Düzeltme: StackTrace null olabilir, bu yüzden ?? StackTrace.current eklendi
      state = AsyncValue.error(e, stackTrace ?? StackTrace.current);
    }
  }

  // Belirli bir dersi getirme
  Future<LessonModel?> getLessonById(int id) async {
    try {
      return await _lessonRepository.getLessonById(id);
    } catch (e, stackTrace) {
      // Düzeltme: StackTrace null olabilir, bu yüzden ?? StackTrace.current eklendi
      state = AsyncValue.error(e, stackTrace ?? StackTrace.current);
      return null;
    }
  }

  // Ders tamamlanma durumunu güncelleme
  Future<void> updateLessonCompletion(int lessonId, bool isCompleted) async {
    try {
      await _lessonRepository.updateLessonCompletion(lessonId, isCompleted);
      await loadLessons();
    } catch (e, stackTrace) {
      // Düzeltme: StackTrace null olabilir, bu yüzden ?? StackTrace.current eklendi
      state = AsyncValue.error(e, stackTrace ?? StackTrace.current);
    }
  }
}

// Lesson notifier provider
final lessonNotifierProvider =
    StateNotifierProvider<LessonNotifier, AsyncValue<List<LessonModel>>>((ref) {
      final lessonRepository = ref.watch(lessonRepositoryProvider);
      return LessonNotifier(lessonRepository);
    });

// Tek bir ders için provider
final lessonProvider = FutureProvider.family<LessonModel?, int>((
  ref,
  lessonId,
) async {
  final lessonRepository = ref.watch(lessonRepositoryProvider);
  try {
    return await lessonRepository.getLessonById(lessonId);
  } catch (e) {
    throw Exception('Ders yüklenirken hata: $e');
  }
});
