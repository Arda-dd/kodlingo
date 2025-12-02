// lib/presentation/widgets/lesson_cards/lesson_card_widget.dart

import 'package:flutter/material.dart';
import '../../../core/routes/app_router.dart';
import '../../../data/models/lesson_model.dart';
import '../common/custom_card.dart';

class LessonCardWidget extends StatelessWidget {
  final LessonModel lesson;
  final bool overrideCompleted; // Dışarıdan gelen tamamlanma bilgisi
  final bool isLocked;

  const LessonCardWidget({
    super.key,
    required this.lesson,
    this.overrideCompleted = false,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    // Modeldeki veri veya UserNotifier'dan gelen veri true ise tamamlanmıştır
    final bool isCompleted = lesson.isCompleted || overrideCompleted;

    IconData iconData;
    Color circleColor;

    if (lesson.type == 'coding') {
      iconData = Icons.code;
      circleColor = Colors.purple.shade300;
    } else {
      iconData = Icons.menu_book;
      circleColor = Colors.blue.shade300;
    }

    if (isCompleted) {
      circleColor = Colors.amber.shade600; // Altın Rengi
    }

    return CustomCard(
      onTap: () {
        if (isLocked) return;

        String routeName = lesson.type == 'coding'
            ? AppRouter.coding
            : AppRouter.lesson;

        Navigator.of(
          context,
        ).pushNamed(routeName, arguments: {'lessonId': lesson.id});
      },
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLocked
                      ? Colors.grey.shade800
                      : circleColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isLocked ? Colors.grey : circleColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  isLocked ? Icons.lock : iconData,
                  color: isLocked ? Colors.grey : circleColor,
                  size: 24,
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 16,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isCompleted
                        ? Colors.amber.shade600
                        : (isLocked ? Colors.grey : Colors.white),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: isCompleted
                ? Icon(Icons.emoji_events, color: Colors.amber.shade600)
                : Text(
                    '+${lesson.xpReward} XP',
                    style: TextStyle(
                      color: isLocked ? Colors.grey : Colors.blue.shade200,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
