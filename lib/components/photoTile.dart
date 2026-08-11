// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'placeholderArtwork.dart';

class PhotoTile extends StatelessWidget {
  const PhotoTile({
    super.key,
    required this.seed,
    this.selected = false,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  final String seed;
  final bool selected;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PlaceholderArtwork(seed: seed),
            if (selected)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.onPrimary, width: 2),
                  ),
                  child: Icon(Icons.check, size: 16, color: scheme.onPrimary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
