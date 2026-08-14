import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/components/photoTile.dart';
import 'package:photogram/screens/albumsScreen.dart';
import 'package:photogram/screens/peopleScreen.dart';
import 'package:photogram/screens/profileScreen.dart';
import 'package:photogram/screens/searchScreen.dart';
import 'package:photogram/theme.dart';

import 'helpers.dart';

void main() {
  Future<void> pumpAlbums(WidgetTester tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const AlbumsScreen()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders top bar, smart albums and your albums sections',
      (tester) async {
    await pumpAlbums(tester);

    expect(find.text('Photogram'), findsOneWidget);
    expect(find.text('Smart Albums'), findsOneWidget);
    expect(find.text('Your Albums'), findsOneWidget);

    expect(find.text('People'), findsOneWidget);
    expect(find.text('Screenshots'), findsOneWidget);
    expect(find.text('Documents'), findsOneWidget);
    expect(find.text('Trips'), findsOneWidget);
    expect(find.text('124 items'), findsOneWidget);
    expect(find.text('89 items'), findsOneWidget);
    expect(find.text('42 items'), findsOneWidget);
    expect(find.text('15 items'), findsOneWidget);

    expect(find.text('Summer 2025'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('July 1 - Aug 15 • 312 photos'), findsOneWidget);
    expect(find.text('48 photos'), findsOneWidget);

    expect(find.byType(PlaceholderArtwork), findsNWidgets(6));
  });

  testWidgets('album thumbnails are squares', (tester) async {
    await pumpAlbums(tester);

    final tiles = find.byType(PlaceholderArtwork);
    for (var i = 0; i < tiles.evaluate().length; i++) {
      final size = tester.getSize(tiles.at(i));
      expect(size.width, size.height, reason: 'thumbnail $i is not square');
    }
  });

  testWidgets('albums tab is active in the bottom nav', (tester) async {
    await pumpAlbums(tester);

    expect(find.byTooltip('Albums'), findsOneWidget);
    expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
  });

  testWidgets('tapping a smart album shows a placeholder snackbar',
      (tester) async {
    await pumpAlbums(tester);

    await tester.tap(find.text('Trips'));
    await tester.pumpAndSettle();

    expect(find.text('Trips album is coming soon.'), findsOneWidget);
  });

  testWidgets('tapping a wide album card shows a placeholder snackbar',
      (tester) async {
    await pumpAlbums(tester);

    await tester.ensureVisible(find.text('Favorites'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();

    expect(find.text('Favorites album is coming soon.'), findsOneWidget);
  });

  testWidgets('People album opens People, a person opens their album, back returns',
      (tester) async {
    await pumpAlbums(tester);

    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();
    expect(find.byType(PeopleScreen), findsOneWidget);

    await tester.tap(find.text('Sarah'));
    await tester.pumpAndSettle();
    expect(find.text('Sarah Miller'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(PeopleScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(AlbumsScreen), findsOneWidget);
  });

  testWidgets('navigates to Search via the top bar and back via the nav',
      (tester) async {
    await pumpAlbums(tester);

    await tester.tap(find.byTooltip('Search').first);
    await tester.pumpAndSettle();
    expect(find.byType(SearchScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Library'));
    await tester.pumpAndSettle();
    expect(find.byType(AlbumsScreen), findsOneWidget);
  });

  testWidgets('navigates to Profile via the bottom nav', (tester) async {
    await pumpAlbums(tester);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
