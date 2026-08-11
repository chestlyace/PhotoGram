// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/photoDetailScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Photo detail renders date, location, people and metadata', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const PhotoDetailScreen()));
    expect(find.text('October 24, 2023'), findsOneWidget);
    expect(find.text('Mount Rainier National Park'), findsOneWidget);
    expect(find.text('Sarah'), findsOneWidget);
    expect(find.text('Sony A7IV • 35mm'), findsOneWidget);
  });
}
