import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/components/photoTile.dart';
import 'package:photogram/screens/personAlbumScreen.dart';
import 'package:photogram/screens/peopleScreen.dart';
import 'package:photogram/screens/profileScreen.dart';
import 'package:photogram/screens/searchScreen.dart';
import 'package:photogram/theme.dart';

import 'helpers.dart';

void main() {
  Future<void> pumpPeople(WidgetTester tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const PeopleScreen()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders top bar, Named and Add names sections', (tester) async {
    await pumpPeople(tester);

    expect(find.text('People'), findsOneWidget);
    expect(find.text('Named'), findsOneWidget);
    expect(find.text('Add names'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(find.byTooltip('Search'), findsWidgets);
  });

  testWidgets('shows the five named people with their avatars', (tester) async {
    await pumpPeople(tester);

    for (final name in ['Elena', 'Marcus', 'Sarah', 'Leo', 'David']) {
      expect(find.text(name), findsOneWidget);
    }
    expect(find.byType(PlaceholderArtwork), findsNWidgets(9));
  });

  testWidgets('shows four faded Add name entries', (tester) async {
    await pumpPeople(tester);

    expect(find.text('ADD NAME'), findsNWidgets(4));
  });

  testWidgets('tapping Sarah opens her person album', (tester) async {
    await pumpPeople(tester);

    await tester.tap(find.text('Sarah'));
    await tester.pumpAndSettle();

    expect(find.byType(PersonAlbumScreen), findsOneWidget);
    expect(find.text('Sarah Miller'), findsOneWidget);
  });

  testWidgets('tapping Marcus opens his person album', (tester) async {
    await pumpPeople(tester);

    await tester.tap(find.text('Marcus'));
    await tester.pumpAndSettle();

    expect(find.byType(PersonAlbumScreen), findsOneWidget);
    expect(find.text('Marcus'), findsOneWidget);
    expect(find.text('Sarah Miller'), findsNothing);
  });

  testWidgets('tapping Add name shows a placeholder snackbar', (tester) async {
    await pumpPeople(tester);

    await tester.tap(find.text('ADD NAME').first);
    await tester.pumpAndSettle();

    expect(find.text('Adding a name is coming soon.'), findsOneWidget);
  });

  testWidgets('navigates to Search via the top bar', (tester) async {
    await pumpPeople(tester);

    await tester.tap(find.byTooltip('Search').first);
    await tester.pumpAndSettle();

    expect(find.byType(SearchScreen), findsOneWidget);
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
    navigator.push(MaterialPageRoute<void>(builder: (_) => const PeopleScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('root'), findsOneWidget);
  });

  testWidgets('albums tab is active in the bottom nav', (tester) async {
    await pumpPeople(tester);

    expect(find.byTooltip('Albums'), findsOneWidget);
  });

  testWidgets('navigates to Profile via the bottom nav', (tester) async {
    await pumpPeople(tester);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
