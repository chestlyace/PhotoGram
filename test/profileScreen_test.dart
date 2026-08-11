// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/profileScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Profile renders identity, storage, accounts and settings', (tester) async {
    tester.view.physicalSize = const Size(1170, 4200);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const ProfileScreen()));
    expect(find.text('Sarah Jenkins'), findsOneWidget);
    expect(find.text('@sjenkins'), findsOneWidget);
    expect(find.text('Connected Accounts'), findsOneWidget);
    expect(find.text('People'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
  });
}
