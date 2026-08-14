import 'package:flutter/material.dart';

import '../theme.dart';
import 'neumorphic.dart';

class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        variant: selected ? NeumorphicVariant.flat : NeumorphicVariant.convex,
        color: selected ? AppColors.activeChip : AppColors.primaryContainer,
        radius: 32,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: selected
                    ? AppColors.onPrimary
                    : AppColors.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
