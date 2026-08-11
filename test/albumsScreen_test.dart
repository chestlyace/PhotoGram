// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/albumsScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Albums renders smart and my albums', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const AlbumsScreen()));
    expect(find.text('Smart Albums'), findsOneWidget);
    expect(find.text('My Albums'), findsOneWidget);
    expect(find.text('People'), findsOneWidget);
    expect(find.text('248 photos'), findsOneWidget);
    expect(find.text('Summer 2025'), findsOneWidget);
    expect(find.text('124 items'), findsOneWidget);
  });
}
