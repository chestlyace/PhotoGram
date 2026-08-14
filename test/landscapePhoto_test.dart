import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/components/photoTile.dart';

void main() {
  testWidgets('renders a full-bleed landscape painting', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox.expand(child: LandscapePhoto(seed: 'detail')),
        ),
      ),
    );

    final paint = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(LandscapePhoto),
        matching: find.byType(CustomPaint),
      ),
    );
    expect(paint.painter, isA<LandscapePhotoPainter>());
    expect(paint.size, const Size(double.infinity, double.infinity));

    expect(tester.takeException(), isNull);
  });

  testWidgets('same seed produces the same painter', (tester) async {
    const a = LandscapePhotoPainter(seed: 'detail');
    const b = LandscapePhotoPainter(seed: 'detail');
    const c = LandscapePhotoPainter(seed: 'other');

    expect(a.shouldRepaint(b), isFalse);
    expect(a.shouldRepaint(c), isTrue);
  });
}
