import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/screens/libraryScreen.dart';
import 'package:photogram/screens/onboardingScreen.dart';
import 'package:photogram/theme.dart';

import 'fakes.dart';
import 'helpers.dart';

void main() {
  FakePhotoLibraryService makeLibraryService() {
    return FakePhotoLibraryService(photos: todayPhotos());
  }

  Future<void> pumpOnboarding(WidgetTester tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: OnboardingScreen(libraryService: makeLibraryService()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> swipe(WidgetTester tester, int pages) async {
    for (var i = 0; i < pages; i++) {
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
    }
  }

  testWidgets('renders the first page with wordmark, art, and dots',
      (tester) async {
    await pumpOnboarding(tester);

    expect(find.text('Photogram'), findsOneWidget);
    expect(find.text('Your memories, beautifully organized.'), findsOneWidget);

    for (var i = 0; i < 4; i++) {
      expect(find.byKey(Key('page-dot-$i')), findsOneWidget);
    }
  });

  testWidgets('first two pages have no skip and no action button',
      (tester) async {
    await pumpOnboarding(tester);

    expect(find.text('Skip'), findsNothing);
    expect(find.text('Continue'), findsNothing);
    expect(find.text('Get started'), findsNothing);

    await swipe(tester, 1);
    expect(find.text('Your photos, your storage.'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Continue'), findsNothing);
    expect(find.text('Get started'), findsNothing);
  });

  testWidgets('swiping moves through the pages in design order',
      (tester) async {
    await pumpOnboarding(tester);

    expect(find.text('Your memories, beautifully organized.'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(find.text('Your photos, your storage.'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(find.text('Memories that happen automatically.'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(find.text('Share the moment.'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(400, 0));
    await tester.pumpAndSettle();
    expect(find.text('Memories that happen automatically.'), findsOneWidget);
  });

  testWidgets('continue button on the automatic page advances', (tester) async {
    await pumpOnboarding(tester);

    await swipe(tester, 2);
    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Share the moment.'), findsOneWidget);
  });

  testWidgets('skip opens the library', (tester) async {
    await pumpOnboarding(tester);

    await swipe(tester, 1);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.byType(LibraryScreen), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
  });

  testWidgets('last page button opens the library and skip still works',
      (tester) async {
    await pumpOnboarding(tester);

    await swipe(tester, 3);

    expect(find.text('Share the moment.'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.byType(LibraryScreen), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
  });

  testWidgets('skip on the last page opens the library', (tester) async {
    await pumpOnboarding(tester);

    await swipe(tester, 3);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.byType(LibraryScreen), findsOneWidget);
  });
}
