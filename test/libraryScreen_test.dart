import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/components/mosaicGrid.dart';
import 'package:photogram/components/photoTile.dart';
import 'package:photogram/models/photoAsset.dart';
import 'package:photogram/screens/albumsScreen.dart';
import 'package:photogram/screens/libraryScreen.dart';
import 'package:photogram/screens/photoViewerScreen.dart';
import 'package:photogram/screens/profileScreen.dart';
import 'package:photogram/screens/searchScreen.dart';
import 'package:photogram/theme.dart';

import 'fakes.dart';
import 'helpers.dart';

void main() {
  List<PhotoAsset> samplePhotos() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 12);
    return [
      makePhoto('a', today),
      makePhoto('b', today.subtract(const Duration(hours: 2))),
      makePhoto('c', today.subtract(const Duration(days: 1, hours: 1))),
    ];
  }

  Future<FakePhotoLibraryService> pumpLibrary(
    WidgetTester tester, {
    FakePhotoLibraryService? service,
  }) async {
    setPhoneSurface(tester);
    final fake = service ?? FakePhotoLibraryService(photos: samplePhotos());
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: LibraryScreen(service: fake),
      ),
    );
    await tester.pumpAndSettle();
    return fake;
  }

  testWidgets('renders header, day sections and photo grid', (tester) async {
    await pumpLibrary(tester);

    expect(find.text('Photogram'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.byType(PhotoTile), findsNWidgets(3));
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('photo tiles are uniform squares sized from the parent',
      (tester) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 12);
    await pumpLibrary(
      tester,
      service: FakePhotoLibraryService(
        photos: [
          makePhoto('a', today),
          makePhoto('b', today.subtract(const Duration(hours: 1))),
          makePhoto('c', today.subtract(const Duration(hours: 2))),
        ],
      ),
    );

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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 12);
    final fake = FakePhotoLibraryService(
      photos: [
        for (var i = 0; i < 8; i++)
          makePhoto('t$i', today.subtract(Duration(hours: i))),
        for (var i = 0; i < 4; i++)
          makePhoto('y$i', today.subtract(Duration(days: 1, hours: i))),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: LibraryScreen(service: fake)),
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

  testWidgets('shows loading indicator while photos load', (tester) async {
    final fake = FakePhotoLibraryService(
      delay: const Duration(milliseconds: 100),
      photos: samplePhotos(),
    );
    setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: LibraryScreen(service: fake)),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(PhotoTile), findsNWidgets(3));
  });

  testWidgets('shows permission prompt and retry flow when denied',
      (tester) async {
    final fake = FakePhotoLibraryService(granted: false);
    await pumpLibrary(tester, service: fake);

    expect(fake.requestCount, 1);
    expect(find.text('Access your photos'), findsOneWidget);
    expect(find.text('Allow access'), findsOneWidget);
    expect(find.text('Open Settings'), findsNothing);

    await tester.tap(find.text('Allow access'));
    await tester.pumpAndSettle();

    expect(fake.requestCount, 2);
    expect(find.text('Open Settings'), findsOneWidget);

    await tester.tap(find.text('Open Settings'));
    expect(fake.openSettingsCalled, isTrue);
  });

  testWidgets('shows empty state when the library has no photos',
      (tester) async {
    await pumpLibrary(tester, service: FakePhotoLibraryService());

    expect(find.text('No photos yet'), findsOneWidget);
    expect(find.byType(PhotoTile), findsNothing);
  });

  testWidgets('tapping a tile opens the full-screen viewer', (tester) async {
    await pumpLibrary(tester);

    await tester.tap(find.byType(PhotoTile).first);
    await tester.pumpAndSettle();

    expect(find.byType(PhotoViewerScreen), findsOneWidget);
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
