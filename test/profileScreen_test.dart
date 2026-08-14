import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/components/neumorphic.dart';
import 'package:photogram/components/photoTile.dart';
import 'package:photogram/screens/personAlbumScreen.dart';
import 'package:photogram/screens/profileScreen.dart';
import 'package:photogram/screens/searchScreen.dart';
import 'package:photogram/theme.dart';

import 'helpers.dart';

void main() {
  Future<void> pumpProfile(WidgetTester tester) async {
    setPhoneSurface(tester, const Size(402, 1600));
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const ProfileScreen()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders header, storage, accounts, people and settings',
      (tester) async {
    await pumpProfile(tester);

    expect(find.text('Sarah Miller'), findsOneWidget);
    expect(find.text('@sarahm'), findsOneWidget);

    expect(find.text('Storage'), findsOneWidget);
    expect(find.text('14.2 GB'), findsOneWidget);
    expect(find.text('of 15 GB used'), findsOneWidget);
    expect(find.text('Manage'), findsOneWidget);

    expect(find.text('CONNECTED ACCOUNTS'), findsOneWidget);
    expect(find.text('Google Photos'), findsOneWidget);
    expect(find.text('Google Calendar'), findsOneWidget);

    expect(find.text('PEOPLE IN YOUR LIBRARY'), findsOneWidget);
    expect(find.text('David'), findsOneWidget);
    expect(find.text('Emma'), findsOneWidget);
    expect(find.text('James'), findsOneWidget);
    expect(find.text('Sophie'), findsOneWidget);

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Privacy & Sharing'), findsOneWidget);
    expect(find.text('Backup preferences'), findsOneWidget);
    expect(find.text('Storage & data'), findsOneWidget);
    expect(find.text('Help & support'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });

  testWidgets('renders the avatar and four person portraits', (tester) async {
    await pumpProfile(tester);

    expect(find.byType(PlaceholderArtwork), findsNWidgets(5));
  });

  testWidgets('storage fill starts flush with the left edge of the track',
      (tester) async {
    await pumpProfile(tester);

    final track = find.byWidgetPredicate(
      (w) =>
          w is Neumorphic &&
          w.variant == NeumorphicVariant.concave &&
          w.radius == 6,
    );
    final fill = find.byWidgetPredicate(
      (w) =>
          w is DecoratedBox &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).color == AppColors.outline,
    );

    expect(track, findsOneWidget);
    expect(fill, findsOneWidget);

    expect(tester.getTopLeft(fill).dx, tester.getTopLeft(track).dx);
    expect(tester.getSize(fill).width, lessThan(tester.getSize(track).width));
  });

  testWidgets('bottom nav shows the active profile tab', (tester) async {
    await pumpProfile(tester);

    expect(find.byTooltip('Profile'), findsOneWidget);
    expect(find.byTooltip('Library'), findsOneWidget);
    expect(find.byTooltip('Albums'), findsOneWidget);
  });

  testWidgets('Manage button shows a placeholder snackbar', (tester) async {
    await pumpProfile(tester);

    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();

    expect(find.text('Storage management is coming soon.'), findsOneWidget);
  });

  testWidgets('settings rows show placeholder snackbars', (tester) async {
    await pumpProfile(tester);

    await tester.tap(find.text('Notifications'));
    await tester.pumpAndSettle();
    expect(find.text('Notifications is coming soon.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Help & support'));
    await tester.pumpAndSettle();
    expect(find.text('Help & support is coming soon.'), findsOneWidget);
  });

  testWidgets('Sign out shows a placeholder snackbar', (tester) async {
    await pumpProfile(tester);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.text('Signing out is coming soon.'), findsOneWidget);
  });

  testWidgets('tapping a person opens the person album', (tester) async {
    await pumpProfile(tester);

    await tester.tap(find.text('David'));
    await tester.pumpAndSettle();

    expect(find.byType(PersonAlbumScreen), findsOneWidget);
  });

  testWidgets('navigates to Search via the top bar', (tester) async {
    await pumpProfile(tester);

    await tester.tap(find.byTooltip('Search').first);
    await tester.pumpAndSettle();

    expect(find.byType(SearchScreen), findsOneWidget);
    expect(find.text('Recent'), findsOneWidget);
  });
}
