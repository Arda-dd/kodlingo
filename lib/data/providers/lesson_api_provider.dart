// API İsteklerini yöneten servis - Ders verileri için
// Bu dosya DATA katmanında yer alır ve harici API ile iletişimi sağlar
// DOMAIN katmanındaki repository'ler bu provider'ı kullanır

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../models/lesson_model.dart';

class LessonApiProvider {
  final http.Client client;

  LessonApiProvider({http.Client? client}) : client = client ?? http.Client();

  // Tüm dersleri getirme
  Future<List<LessonModel>> getLessons() async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.lessonsEndpoint}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => LessonModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Dersler yüklenirken hata oluştu: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('API hatası: $e');
    }
  }

  // Belirli bir dersi getirme
  Future<LessonModel> getLessonById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.lessonsEndpoint}/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LessonModel.fromJson(data);
      } else {
        throw Exception('Ders yüklenirken hata oluştu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API hatası: $e');
    }
  }

  // Ders tamamlanma durumunu güncelleme
  Future<void> updateLessonCompletion(int lessonId, bool isCompleted) async {
    try {
      final response = await client.put(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.lessonsEndpoint}/$lessonId/completion',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'is_completed': isCompleted}),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Ders güncellenirken hata oluştu: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('API hatası: $e');
    }
  }
}
