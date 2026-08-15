import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/main.dart';

import 'fakes.dart';
import 'helpers.dart';

void main() {
  testWidgets('app boots into the onboarding flow', (tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      const PhotogramApp(),
    );
    await tester.pumpAndSettle();

    expect(find.text('Photogram'), findsOneWidget);
    expect(find.text('Your memories, beautifully organized.'), findsOneWidget);
  });

  testWidgets('skipping onboarding reaches the Library', (tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      PhotogramApp(
        libraryService: FakePhotoLibraryService(photos: todayPhotos()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);
  });
}
