// State Management - Ders verileri için durum yöneticisi
// Bu dosya DOMAIN katmanında yer alır ve UI state'ini yönetir
// Riverpod kullanarak reactive state management sağlar

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/lesson_repository.dart';

// Lesson repository provider (dependency injection için)
final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  // Gerçek uygulamada dependency injection container'dan alınacak
  throw UnimplementedError('LessonRepository henüz implement edilmemiş');
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
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Belirli bir dersi getirme
  Future<LessonModel?> getLessonById(int id) async {
    try {
      return await _lessonRepository.getLessonById(id);
    } catch (e) {
      state = AsyncValue.error(e, state.stackTrace);
      return null;
    }
  }

  // Ders tamamlanma durumunu güncelleme
  Future<void> updateLessonCompletion(int lessonId, bool isCompleted) async {
    try {
      await _lessonRepository.updateLessonCompletion(lessonId, isCompleted);
      // Listeyi yeniden yükle
      await loadLessons();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
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
