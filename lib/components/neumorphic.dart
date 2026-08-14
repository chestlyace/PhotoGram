import 'package:flutter/material.dart';

import '../theme.dart';

enum NeumorphicVariant { convex, concave, flat }

class Neumorphic extends StatelessWidget {
  const Neumorphic({
    super.key,
    this.variant = NeumorphicVariant.convex,
    this.radius = AppRadii.card,
    this.padding,
    this.color = AppColors.canvas,
    this.child,
  });

  final NeumorphicVariant variant;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    final surface = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow:
            variant == NeumorphicVariant.convex ? NeumorphicShadows.convex : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
    if (variant != NeumorphicVariant.concave) {
      return surface;
    }
    return CustomPaint(
      foregroundPainter: _InnerShadowPainter(
        radius: radius,
        shadows: NeumorphicShadows.concave,
      ),
      child: surface,
    );
  }
}

class _InnerShadowPainter extends CustomPainter {
  const _InnerShadowPainter({required this.radius, required this.shadows});

  final double radius;
  final List<BoxShadow> shadows;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    canvas.clipRRect(rrect);
    for (final shadow in shadows) {
      final shifted = path.shift(shadow.offset);
      canvas.saveLayer(rect, Paint());
      canvas.drawPath(
        shifted,
        Paint()
          ..color = shadow.color
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius),
      );
      canvas.drawPath(shifted, Paint()..blendMode = BlendMode.dstOut);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _InnerShadowPainter oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.shadows != shadows;
}
