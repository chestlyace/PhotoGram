import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/components/mosaicGrid.dart';
import 'package:photogram/components/photoTile.dart';
import 'package:photogram/screens/personAlbumScreen.dart';
import 'package:photogram/screens/photoDetailScreen.dart';
import 'package:photogram/screens/profileScreen.dart';
import 'package:photogram/screens/searchScreen.dart';
import 'package:photogram/theme.dart';

import 'helpers.dart';

void main() {
  Future<void> pumpPersonAlbum(WidgetTester tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const PersonAlbumScreen()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders header with avatar, name and rename button',
      (tester) async {
    await pumpPersonAlbum(tester);

    expect(find.text('Sarah Miller'), findsOneWidget);
    expect(find.text('RENAME'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
  });

  testWidgets('renders the given person name when provided', (tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const PersonAlbumScreen(personName: 'Marcus'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Marcus'), findsOneWidget);
    expect(find.text('Sarah Miller'), findsNothing);
  });

  testWidgets('renders the nine-photo gapless grid', (tester) async {
    await pumpPersonAlbum(tester);

    final grid = tester.widget<MosaicGrid>(find.byType(MosaicGrid));
    expect(grid.spans.length, 9);
    expect(isPackedLayout(grid.spans, grid.columnCount), isTrue);

    expect(find.byType(PlaceholderArtwork), findsNWidgets(10));
  });

  testWidgets('photo tiles are squares sized from the parent', (tester) async {
    await pumpPersonAlbum(tester);

    final grid = tester.widget<MosaicGrid>(find.byType(MosaicGrid));
    final cell =
        (kTestCanvas.width - 2 * AppSpacing.containerMargin) / grid.columnCount;

    final sizes = <Size>{};
    final tiles = find.byType(PlaceholderArtwork);
    for (var i = 0; i < tiles.evaluate().length; i++) {
      final size = tester.getSize(tiles.at(i));
      expect(size.width, size.height, reason: 'tile $i is not square');
      sizes.add(size);
    }

    expect(sizes, contains(Size(cell, cell)));
  });

  testWidgets('rename button shows a placeholder snackbar', (tester) async {
    await pumpPersonAlbum(tester);

    await tester.tap(find.text('RENAME'));
    await tester.pumpAndSettle();

    expect(find.text('Renaming is coming soon.'), findsOneWidget);
  });

  testWidgets('albums tab is active in the bottom nav', (tester) async {
    await pumpPersonAlbum(tester);

    expect(find.byTooltip('Albums'), findsOneWidget);
  });

  testWidgets('navigates to Search via the top bar', (tester) async {
    await pumpPersonAlbum(tester);

    await tester.tap(find.byTooltip('Search').first);
    await tester.pumpAndSettle();

    expect(find.byType(SearchScreen), findsOneWidget);
  });

  testWidgets('tapping a photo tile opens the photo detail screen',
      (tester) async {
    await pumpPersonAlbum(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(MosaicGrid),
        matching: find.byType(PlaceholderArtwork),
      ).first,
    );
    await tester.pumpAndSettle();

    expect(find.byType(PhotoDetailScreen), findsOneWidget);
    expect(find.text('CAPTURED'), findsOneWidget);
  });

  testWidgets('navigates to Profile via the bottom nav', (tester) async {
    await pumpPersonAlbum(tester);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
