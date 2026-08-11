// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../theme.dart';

class OnboardingDots extends StatelessWidget {
  const OnboardingDots({super.key, required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++)
          Container(
            width: i == activeIndex ? 32 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: i == activeIndex
                  ? AppColors.primary
                  : AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}
