import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/components/photoTile.dart';
import 'package:photogram/screens/albumsScreen.dart';
import 'package:photogram/screens/eventMemoryScreen.dart';
import 'package:photogram/screens/photoDetailScreen.dart';
import 'package:photogram/theme.dart';

import 'helpers.dart';

void main() {
  Future<void> pumpEvent(WidgetTester tester) async {
    setPhoneSurface(tester, const Size(402, 1200));
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const EventMemoryScreen()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the event memory layout', (tester) async {
    await pumpEvent(tester);

    expect(find.text('Summer Vacation 2025'), findsOneWidget);
    expect(find.text('July 15 - Aug 1'), findsOneWidget);
    expect(find.text('Highlights'), findsOneWidget);

    expect(find.byType(PlaceholderArtwork), findsNWidgets(5));
    expect(find.byType(PhotoTile), findsNWidgets(4));

    expect(find.text('Share'), findsOneWidget);
    expect(find.byTooltip('Link'), findsOneWidget);
    expect(find.byTooltip('Chat'), findsOneWidget);
    expect(find.byTooltip('Email'), findsOneWidget);
    expect(find.byTooltip('Apps'), findsOneWidget);
  });

  testWidgets('share and action buttons show placeholder snackbars',
      (tester) async {
    await pumpEvent(tester);

    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();
    expect(find.text('Sharing is coming soon.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Chat'));
    await tester.pumpAndSettle();
    expect(find.text('Chat is coming soon.'), findsOneWidget);
  });

  testWidgets('tapping a highlight opens the photo detail screen',
      (tester) async {
    await pumpEvent(tester);

    await tester.tap(find.byType(PhotoTile).first);
    await tester.pumpAndSettle();

    expect(find.byType(PhotoDetailScreen), findsOneWidget);
  });

  testWidgets('back button pops to the previous screen', (tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const AlbumsScreen()),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Summer 2025'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Summer 2025'));
    await tester.pumpAndSettle();
    expect(find.byType(EventMemoryScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.byType(EventMemoryScreen), findsNothing);
    expect(find.byType(AlbumsScreen), findsOneWidget);
  });
}
