import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color background = Color(0xFFF9F9F7);
  static const Color primary = Color(0xFF030813);
  static const Color primaryContainer = Color(0xFF1A202C);
  static const Color primaryFixed = Color(0xFFDDE2F3);
  static const Color secondary = Color(0xFF545F72);
  static const Color onSurface = Color(0xFF1A1C1B);
  static const Color onSurfaceVariant = Color(0xFF45474C);
  static const Color outline = Color(0xFF76777C);
  static const Color outlineVariant = Color(0xFFC6C6CC);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF4F4F2);
  static const Color surfaceContainer = Color(0xFFEEEEEC);
  static const Color surfaceContainerHigh = Color(0xFFE8E8E6);
  static const Color surfaceContainerHighest = Color(0xFFE2E3E1);
  static const Color surfaceVariant = Color(0xFFE2E3E1);
  static const Color secondaryContainer = Color(0xFFD5E0F7);
  static const Color onSecondaryContainer = Color(0xFF586377);
  static const Color success = Color(0xFF166534);
  static const Color error = Color(0xFFBA1A1A);
}

ThemeData buildAppTheme() {
  final base = ColorScheme.fromSeed(seedColor: AppColors.primaryContainer);
  final scheme = base.copyWith(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: Colors.white,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    surface: AppColors.background,
    onSurface: AppColors.onSurface,
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
  );
}
