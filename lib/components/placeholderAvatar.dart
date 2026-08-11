// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'placeholderArtwork.dart';

class PlaceholderAvatar extends StatelessWidget {
  const PlaceholderAvatar({super.key, required this.seed, this.size = 32});

  final String seed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: PlaceholderArtwork(seed: seed, icon: Icons.person, iconSize: size * 0.5),
      ),
    );
  }
}
