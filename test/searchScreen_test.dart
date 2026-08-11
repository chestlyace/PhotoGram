// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/searchScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Search renders input, chips, recent searches and content types', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const SearchScreen()));
    expect(find.text('Recent Searches'), findsOneWidget);
    expect(find.text('Content Types'), findsOneWidget);
    expect(find.text('Screenshots'), findsOneWidget);
    expect(find.text('"dog at the beach"'), findsOneWidget);
    expect(find.text('ID Cards'), findsOneWidget);
  });
}
