import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/components/photoTile.dart';
import 'package:photogram/screens/personAlbumScreen.dart';
import 'package:photogram/screens/photoDetailScreen.dart';
import 'package:photogram/theme.dart';

import 'helpers.dart';

void main() {
  Future<void> pumpDetail(WidgetTester tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const PhotoDetailScreen()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders date, share, people, albums and meta', (tester) async {
    await pumpDetail(tester);

    expect(find.text('CAPTURED'), findsOneWidget);
    expect(find.text('October 14, 2024'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(find.byTooltip('Share'), findsOneWidget);

    expect(find.text('In this photo'), findsOneWidget);
    expect(find.text('Sarah M.'), findsOneWidget);
    expect(find.text('David K.'), findsOneWidget);

    expect(find.text('Albums'), findsOneWidget);
    expect(find.text('Summer 2025'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);

    expect(find.text('Yosemite Valley'), findsOneWidget);
    expect(find.text('Sony A7IV'), findsOneWidget);

    expect(find.byType(LandscapePhoto), findsOneWidget);
  });

  testWidgets('share button shows a placeholder snackbar', (tester) async {
    await pumpDetail(tester);

    await tester.tap(find.byTooltip('Share'));
    await tester.pumpAndSettle();

    expect(find.text('Sharing is coming soon.'), findsOneWidget);
  });

  testWidgets('album pills show a placeholder snackbar', (tester) async {
    await pumpDetail(tester);

    await tester.tap(find.text('Summer 2025'));
    await tester.pumpAndSettle();
    expect(find.text('Summer 2025 album is coming soon.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Favorites album is coming soon.'), findsOneWidget);
  });

  testWidgets('tapping Sarah M. opens her person album', (tester) async {
    await pumpDetail(tester);

    await tester.tap(find.text('Sarah M.'));
    await tester.pumpAndSettle();

    expect(find.byType(PersonAlbumScreen), findsOneWidget);
    expect(find.text('Sarah Miller'), findsOneWidget);
  });

  testWidgets('back button returns to the previous screen', (tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const Scaffold(body: Center(child: Text('root'))),
      ),
    );
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const PhotoDetailScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('root'), findsOneWidget);
  });
}
