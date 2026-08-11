// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/settingsScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Settings renders storage options', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const SettingsScreen()));
    expect(find.text('Storage Options'), findsOneWidget);
    expect(find.text('Use Photogram Storage'), findsOneWidget);
    expect(find.text('Recommended'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Connect my own Telegram'), findsOneWidget);
  });
}
