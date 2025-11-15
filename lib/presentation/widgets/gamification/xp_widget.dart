// XP gösteren widget
// Bu dosya PRESENTATION katmanında yer alır ve gamification UI bileşenlerini sağlar

import 'package:flutter/material.dart';

class XpWidget extends StatelessWidget {
  final int xp;

  const XpWidget({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.blue.shade600, size: 16),
          const SizedBox(width: 4),
          Text(
            '$xp XP',
            style: TextStyle(
              color: Colors.blue.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
