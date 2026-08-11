// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../theme.dart';

class StickySectionHeader extends StatelessWidget {
  const StickySectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(pinned: true, delegate: _SectionHeaderDelegate(title));
  }
}

class _SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _SectionHeaderDelegate(this.title);

  final String title;

  @override
  double get minExtent => 40;
  @override
  double get maxExtent => 40;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background.withValues(alpha: 0.92),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.onSurface),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SectionHeaderDelegate oldDelegate) {
    return oldDelegate.title != title;
  }
}
