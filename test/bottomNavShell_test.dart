// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/components/bottomNavShell.dart';
import 'package:untitled/theme.dart';

int shellIndex(WidgetTester tester) =>
    tester.widget<IndexedStack>(find.byType(IndexedStack)).index!;

void main() {
  testWidgets('bottom nav switches between the four tabs', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const BottomNavShell()));

    expect(find.text('Today'), findsOneWidget);
    expect(shellIndex(tester), 0);

    await tester.tap(find.descendant(of: find.byKey(const Key('bottomNav')), matching: find.text('Search')));
    await tester.pumpAndSettle();
    expect(find.text('Recent Searches'), findsOneWidget);
    expect(shellIndex(tester), 1);

    await tester.tap(find.descendant(of: find.byKey(const Key('bottomNav')), matching: find.text('Albums')));
    await tester.pumpAndSettle();
    expect(find.text('Smart Albums'), findsOneWidget);
    expect(shellIndex(tester), 2);

    await tester.tap(find.descendant(of: find.byKey(const Key('bottomNav')), matching: find.text('Profile')));
    await tester.pumpAndSettle();
    expect(find.text('Sarah Jenkins'), findsOneWidget);
    expect(shellIndex(tester), 3);
  });

  testWidgets('initialIndex starts on the requested tab', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const BottomNavShell(initialIndex: 2)));
    expect(find.text('Smart Albums'), findsOneWidget);
    expect(shellIndex(tester), 2);
  });
}
