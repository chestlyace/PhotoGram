// ignore_for_file: file_names

import 'package:flutter/material.dart';

const List<Color> kPlaceholderPalette = [
  Color(0xFFD8DAE0),
  Color(0xFFC7D3E4),
  Color(0xFFD9E1DC),
  Color(0xFFE4DAD5),
  Color(0xFFD2D8E9),
  Color(0xFFDCD4CB),
  Color(0xFFDEE3D8),
  Color(0xFFDAD5DC),
];

Color placeholderColorFor(String seed) {
  return kPlaceholderPalette[seed.hashCode.abs() % kPlaceholderPalette.length];
}

class PlaceholderArtwork extends StatelessWidget {
  const PlaceholderArtwork({
    super.key,
    required this.seed,
    this.icon = Icons.photo_outlined,
    this.iconSize = 32,
  });

  final String seed;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: placeholderColorFor(seed),
      child: Center(
        child: Icon(icon, size: iconSize, color: Colors.white.withValues(alpha: 0.85)),
      ),
    );
  }
}
