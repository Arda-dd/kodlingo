// Can gösteren widget
// Bu dosya PRESENTATION katmanında yer alır ve gamification UI bileşenlerini sağlar

import 'package:flutter/material.dart';

class CanWidget extends StatelessWidget {
  final int cans;

  const CanWidget({super.key, required this.cans});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, color: Colors.red.shade600, size: 16),
          const SizedBox(width: 4),
          Text(
            '$cans',
            style: TextStyle(
              color: Colors.red.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
