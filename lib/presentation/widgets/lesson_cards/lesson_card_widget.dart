// lib/presentation/widgets/lesson_cards/lesson_card_widget.dart

import 'package:flutter/material.dart';
import '../../../core/routes/app_router.dart';
import '../../../data/models/lesson_model.dart';
import '../common/custom_card.dart';

class LessonCardWidget extends StatelessWidget {
  final LessonModel lesson;

  const LessonCardWidget({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    // Ders tipine göre ikon ve renk belirleme
    IconData iconData;
    Color color;
    if (lesson.type == 'coding') {
      iconData = Icons.code;
      color = Colors.purple.shade300;
    } else {
      iconData = Icons.menu_book;
      color = Colors.blue.shade300;
    }

    // Tamamlanmış dersin rengini değiştirme
    if (lesson.isCompleted) {
      color = Colors.green.shade600;
    }

    return CustomCard(
      onTap: () {
        // Tıklama sonrası yönlendirme mantığı
        String routeName = lesson.type == 'coding'
            ? AppRouter.coding
            : AppRouter.lesson;
        Navigator.of(
          context,
        ).pushNamed(routeName, arguments: {'lessonId': lesson.id});
      },
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surface, // Koyu temaya uyumlu
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(iconData, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // XP ödülü göstergesi
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              '+${lesson.xpReward} XP',
              style: TextStyle(
                color: Colors.yellow.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
