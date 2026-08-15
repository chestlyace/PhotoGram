import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photogram/screens/photoViewerScreen.dart';
import 'package:photogram/theme.dart';

import 'fakes.dart';
import 'helpers.dart';

void main() {
  Future<void> pumpViewer(
    WidgetTester tester, {
    int initialIndex = 0,
    int photoCount = 2,
  }) async {
    setPhoneSurface(tester);
    final now = DateTime.now();
    final photos = [
      for (var i = 0; i < photoCount; i++)
        makePhoto('$i', now.subtract(Duration(hours: i))),
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: PhotoViewerScreen(photos: photos, initialIndex: initialIndex),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the initial photo with a counter', (tester) async {
    await pumpViewer(tester);

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('1 / 2'), findsOneWidget);
  });

  testWidgets('swiping moves to the next photo', (tester) async {
    await pumpViewer(tester);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text('2 / 2'), findsOneWidget);
  });

  testWidgets('back button pops the viewer', (tester) async {
    setPhoneSurface(tester);
    final now = DateTime.now();
    final photos = [makePhoto('a', now), makePhoto('b', now)];
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PhotoViewerScreen(
                      photos: photos,
                      initialIndex: 0,
                    ),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(PhotoViewerScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(PhotoViewerScreen), findsNothing);
  });
}
