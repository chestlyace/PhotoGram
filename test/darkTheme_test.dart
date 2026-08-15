import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/main.dart';
import 'package:photogram/theme.dart';

import 'helpers.dart';

void main() {
  tearDown(() => AppColors.setDark(false));

  testWidgets('dark palette resolves to dark tokens', (tester) async {
    AppColors.setDark(true);

    expect(AppColors.isDark, isTrue);
    expect(AppColors.canvas, const Color(0xFF17191D));
    expect(AppColors.onSurface, const Color(0xFFE6E9EE));

    await tester.pumpWidget(MaterialApp(
      theme: buildAppTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.dark,
      home: const Scaffold(body: SizedBox()),
    ));

    final context = tester.element(find.byType(Scaffold));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(Theme.of(context).scaffoldBackgroundColor, AppColors.canvas);
  });

  testWidgets('light palette is the default and used by the light theme',
      (tester) async {
    expect(AppColors.isDark, isFalse);
    expect(AppColors.canvas, const Color(0xFFF0F2F5));

    await tester.pumpWidget(MaterialApp(
      theme: buildAppTheme(),
      home: const Scaffold(body: SizedBox()),
    ));

    final context = tester.element(find.byType(Scaffold));
    expect(Theme.of(context).brightness, Brightness.light);
    expect(Theme.of(context).scaffoldBackgroundColor, AppColors.canvas);
  });

  testWidgets('PhotogramApp follows the system brightness', (tester) async {
    setPhoneSurface(tester);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await tester.pumpWidget(const PhotogramApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.text('Photogram'));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(Theme.of(context).scaffoldBackgroundColor, const Color(0xFF17191D));
    expect(AppColors.isDark, isTrue);
  });

  testWidgets('PhotogramApp switches theme when brightness changes at runtime',
      (tester) async {
    setPhoneSurface(tester);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await tester.pumpWidget(const PhotogramApp());
    await tester.pumpAndSettle();
    expect(
        Theme.of(tester.element(find.text('Photogram'))).brightness,
        Brightness.light);

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();

    final context = tester.element(find.text('Photogram'));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(
        Theme.of(context).scaffoldBackgroundColor, const Color(0xFF17191D));
  });
}
