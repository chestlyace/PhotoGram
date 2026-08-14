import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/components/mosaicGrid.dart';
import 'package:photogram/components/photoTile.dart';
import 'package:photogram/screens/albumsScreen.dart';
import 'package:photogram/screens/libraryScreen.dart';
import 'package:photogram/screens/profileScreen.dart';
import 'package:photogram/screens/searchScreen.dart';
import 'package:photogram/theme.dart';

import 'helpers.dart';

void main() {
  Future<void> pumpLibrary(WidgetTester tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const LibraryScreen()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders header, sections and photo grid', (tester) async {
    await pumpLibrary(tester);

    expect(find.text('Photogram'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('March 2026'), findsOneWidget);
    expect(find.byType(PhotoTile), findsNWidgets(11));
    expect(find.text('5'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
  });

  testWidgets('photo tiles are uniform squares sized from the parent',
      (tester) async {
    await pumpLibrary(tester);

    final grid = tester.widget<MosaicGrid>(find.byType(MosaicGrid).first);
    final cell =
        (kTestCanvas.width - 2 * AppSpacing.containerMargin) / grid.columnCount;

    final sizes = <Size>{};
    final tiles = find.byType(PhotoTile);
    for (var i = 0; i < tiles.evaluate().length; i++) {
      sizes.add(tester.getSize(tiles.at(i)));
    }

    expect(sizes, {Size(cell, cell)});
  });

  testWidgets('library mosaics are packed with no holes', (tester) async {
    await pumpLibrary(tester);

    final grids = tester.widgetList<MosaicGrid>(find.byType(MosaicGrid));
    expect(grids.length, 2);
    for (final grid in grids) {
      expect(isPackedLayout(grid.spans, grid.columnCount), isTrue,
          reason: 'library grid has holes');
    }

    for (var n = 0; n <= 11; n++) {
      expect(isPackedLayout(packedSpans(n), 3), isTrue,
          reason: 'packedSpans($n) leaves holes');
    }
  });

  testWidgets('shows add snackbar when FAB is tapped', (tester) async {
    await pumpLibrary(tester);

    await tester.tap(find.byTooltip('Add photos'));
    await tester.pumpAndSettle();

    expect(find.text('Import is coming soon.'), findsOneWidget);
  });

  testWidgets('bottom nav shows active library tab and three other tabs',
      (tester) async {
    await pumpLibrary(tester);

    expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsNWidgets(2));
    expect(find.byIcon(Icons.auto_stories_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
  });

  testWidgets('header camera and search buttons are present',
      (tester) async {
    await pumpLibrary(tester);

    expect(find.byTooltip('Camera'), findsOneWidget);
    expect(find.byTooltip('Search'), findsNWidgets(2));
  });

  testWidgets('FAB fades out when content is scrolled', (tester) async {
    setPhoneSurface(tester, const Size(402, 600));
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const LibraryScreen()),
    );
    await tester.pumpAndSettle();

    AnimatedOpacity fabOf(WidgetTester t) => t.widget<AnimatedOpacity>(
          find.ancestor(
            of: find.byTooltip('Add photos'),
            matching: find.byType(AnimatedOpacity),
          ),
        );

    expect(fabOf(tester).opacity, 1);

    await tester.drag(find.text('Today'), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(fabOf(tester).opacity, 0);
  });

  testWidgets('canvas color is the Aura Soft UI base', (tester) async {
    await pumpLibrary(tester);

    final context = tester.element(find.byType(Scaffold));
    expect(Theme.of(context).scaffoldBackgroundColor, AppColors.canvas);
  });

  testWidgets('navigates to Search via the top bar button and back via the nav',
      (tester) async {
    await pumpLibrary(tester);

    await tester.tap(find.byTooltip('Search').first);
    await tester.pumpAndSettle();
    expect(find.byType(SearchScreen), findsOneWidget);
    expect(find.text('Recent'), findsOneWidget);

    await tester.tap(find.byTooltip('Library'));
    await tester.pumpAndSettle();
    expect(find.byType(LibraryScreen), findsOneWidget);
  });

  testWidgets('navigates to Albums via the bottom nav and back',
      (tester) async {
    await pumpLibrary(tester);

    await tester.tap(find.byTooltip('Albums'));
    await tester.pumpAndSettle();
    expect(find.byType(AlbumsScreen), findsOneWidget);
    expect(find.text('Smart Albums'), findsOneWidget);

    await tester.tap(find.byTooltip('Library'));
    await tester.pumpAndSettle();
    expect(find.byType(LibraryScreen), findsOneWidget);
  });

  testWidgets('navigates to Profile via the bottom nav', (tester) async {
    await pumpLibrary(tester);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('Sarah Miller'), findsOneWidget);
  });
}
