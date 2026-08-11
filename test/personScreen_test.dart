// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/personScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Person renders profile header and photo sections', (tester) async {
    tester.view.physicalSize = const Size(1170, 4200);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const PersonScreen()));
    expect(find.text('Emma'), findsOneWidget);
    expect(find.text('42 Photos'), findsOneWidget);
    expect(find.text('Recent'), findsOneWidget);
    expect(find.text('Last Summer'), findsOneWidget);
  });
}
