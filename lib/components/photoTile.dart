import 'package:flutter/material.dart';

/// Seeded placeholder artwork for a photo tile. Swapping in real assets
/// later only touches this widget, never call sites.
class PlaceholderArtwork extends StatelessWidget {
  const PlaceholderArtwork({super.key, required this.seed, this.variation = 0});

  final String seed;
  final int variation;

  @override
  Widget build(BuildContext context) {
    final hue = (seed.hashCode % 36).abs().toDouble() * 10;
    final base = HSLColor.fromAHSL(1, hue, 0.35, 0.62);
    final accent = base.withLightness(0.5);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [base.withAlpha(0.85).toColor(), accent.withAlpha(0.55).toColor()],
        ),
      ),
      child: CustomPaint(
        painter: _ArtworkPainter(seed: seed, variation: variation),
      ),
    );
  }
}

class PhotoTile extends StatelessWidget {
  const PhotoTile({super.key, required this.seed, this.variation = 0});

  final String seed;
  final int variation;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PlaceholderArtwork(seed: seed, variation: variation),
    );
  }
}

/// Seeded placeholder for full-bleed photo heroes. Paints a high-key
/// black-and-white mountain landscape so detail screens read as photography,
/// not abstract art. Swapping in real assets only touches this widget.
class LandscapePhoto extends StatelessWidget {
  const LandscapePhoto({super.key, required this.seed});

  final String seed;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LandscapePhotoPainter(seed: seed),
      size: Size.infinite,
    );
  }
}

class LandscapePhotoPainter extends CustomPainter {
  const LandscapePhotoPainter({required this.seed});

  final String seed;

  static const _skyTop = Color(0xFFFBFCFD);
  static const _skyBottom = Color(0xFFE4E9EE);

  static const _ridges = [
    (base: 0.70, amplitude: 0.16, segments: 16, color: Color(0xFFB4BDC6)),
    (base: 0.84, amplitude: 0.22, segments: 16, color: Color(0xFF6D7883)),
    (base: 0.96, amplitude: 0.30, segments: 16, color: Color(0xFF262C33)),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }
    final rng = _SeededRandom(seed.hashCode);

    final skyRect = Offset.zero & size;
    canvas.drawRect(
      skyRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_skyTop, _skyBottom],
        ).createShader(skyRect),
    );

    final glowCenter = Offset(size.width * 0.5, size.height * 0.30);
    final glowRadius = size.height * 0.3;
    canvas.drawCircle(
      glowCenter,
      glowRadius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0x00FFFFFF)],
        ).createShader(
          Rect.fromCircle(center: glowCenter, radius: glowRadius),
        ),
    );

    for (final ridge in _ridges) {
      _drawRidge(canvas, size, rng, ridge.base, ridge.amplitude, ridge.segments,
          ridge.color);
    }

    final mistRect = Rect.fromLTWH(
      0,
      size.height * 0.80,
      size.width,
      size.height * 0.20,
    );
    canvas.drawRect(
      mistRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00FFFFFF), Color(0x8CFFFFFF)],
        ).createShader(mistRect),
    );
  }

  void _drawRidge(
    Canvas canvas,
    Size size,
    _SeededRandom rng,
    double base,
    double amplitude,
    int segments,
    Color color,
  ) {
    final path = Path()..moveTo(0, size.height);
    for (var i = 0; i <= segments; i++) {
      final height = base - amplitude * (0.15 + rng.nextDouble() * 0.45);
      path.lineTo(size.width * i / segments, height * size.height);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant LandscapePhotoPainter oldDelegate) =>
      oldDelegate.seed != seed;
}

class _ArtworkPainter extends CustomPainter {
  const _ArtworkPainter({required this.seed, required this.variation});

  final String seed;
  final int variation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.28);
    final rng = _SeededRandom(seed.hashCode ^ (variation * 31));

    final arcCount = 3 + rng.nextInt(2);
    for (var i = 0; i < arcCount; i++) {
      final rect = Rect.fromCircle(
        center: Offset(
          size.width * (0.15 + rng.nextDouble() * 0.7),
          size.height * (0.2 + rng.nextDouble() * 0.6),
        ),
        radius: size.shortestSide * (0.2 + rng.nextDouble() * 0.3),
      );
      final start = rng.nextDouble() * 1.5;
      canvas.drawArc(rect, start, 1.6, false, paint..strokeWidth = size.shortestSide * 0.06);
    }
  }

  @override
  bool shouldRepaint(covariant _ArtworkPainter oldDelegate) =>
      oldDelegate.seed != seed || oldDelegate.variation != variation;
}

class _SeededRandom {
  _SeededRandom(int seed) : _state = seed;

  int _state;

  int nextInt(int max) {
    _state = (_state * 1664525 + 1013904223) & 0x7fffffff;
    return _state % max;
  }

  double nextDouble() => nextInt(1 << 24) / (1 << 24);
}
