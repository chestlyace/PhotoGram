// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/eventScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Event renders memory content and opens the share sheet', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const EventScreen()));
    expect(find.text('Summer 2025'), findsOneWidget);
    expect(find.text('Memory Highlights'), findsOneWidget);
    expect(find.text('All Photos (142)'), findsOneWidget);
    expect(find.text('+139'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Share Memory'), findsOneWidget);
  });
}
