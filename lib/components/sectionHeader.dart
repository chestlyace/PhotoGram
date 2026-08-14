import 'package:flutter/material.dart';

import '../theme.dart';
import 'neumorphic.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(width: 8),
          Neumorphic(
            radius: 12,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Text(
              '$count',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: AppColors.onPrimaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
