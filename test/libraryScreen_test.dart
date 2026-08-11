// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/libraryScreen.dart';
import 'package:untitled/screens/settingsScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Library renders sections, photo grid and upload FAB', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const LibraryScreen()));
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('March 2026'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Library FAB opens Upload & Storage', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildAppTheme(),
      routes: {
        '/library': (_) => const LibraryScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
      home: const LibraryScreen(),
    ));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Upload & Storage'), findsOneWidget);
  });
}
