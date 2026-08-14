import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color canvas = Color(0xFFF0F2F5);
  static const Color highlight = Color(0xFFFFFFFF);
  static const Color shadow = Color(0xFFD1D9E6);

  static const Color onSurface = Color(0xFF151C27);
  static const Color onSurfaceVariant = Color(0xFF44474A);
  static const Color outline = Color(0xFF74777A);
  static const Color outlineVariant = Color(0xFFC4C7C9);

  static const Color primary = Color(0xFF5C5F61);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFF0F2F5);
  static const Color onPrimaryContainer = Color(0xFF6B6E71);
  static const Color activeChip = Color(0xFF2B2D31);
  static const Color secondary = Color(0xFF5D5E63);
  static const Color onSecondaryContainer = Color(0xFF616267);
  static const Color tertiary = Color(0xFF575F6A);
  static const Color onTertiaryContainer = Color(0xFF666E7A);

  static const Color surface = Color(0xFFF9F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF0F3FF);
  static const Color surfaceContainer = Color(0xFFE7EEFE);
  static const Color surfaceContainerHigh = Color(0xFFE2E8F8);
  static const Color surfaceContainerHighest = Color(0xFFDCE2F3);

  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
}

abstract final class AppSpacing {
  static const double containerMargin = 24;
  static const double sectionGap = 48;
}

abstract final class AppRadii {
  static const double card = 24;
  static const double control = 16;
  static const double grid = 24;
  static const double headerPill = 28;
  static const double headerButton = 16;
  static const double navPill = 30;
  static const double navItem = 20;
}

abstract final class NeumorphicShadows {
  /// Raised (convex) surface: light top-left, dark bottom-right. Dense and
  /// tight so elements read as paper stacked on the canvas rather than
  /// soft blobs.
  static const List<BoxShadow> convex = [
    BoxShadow(
      color: AppColors.highlight,
      offset: Offset(-4, -4),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadow,
      offset: Offset(4, 4),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  /// Pressed (concave) surface: dark inset from top-left, light from
  /// bottom-right. Consumed by [Neumorphic]'s inner-shadow painter.
  static const List<BoxShadow> concave = [
    BoxShadow(
      color: AppColors.shadow,
      offset: Offset(3, 3),
      blurRadius: 3,
    ),
    BoxShadow(
      color: AppColors.highlight,
      offset: Offset(-3, -3),
      blurRadius: 3,
    ),
  ];
}

ThemeData buildAppTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.surfaceContainerLow,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: Colors.white,
    tertiaryContainer: AppColors.surfaceContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: AppColors.shadow,
    scrim: Color(0x66000000),
    inverseSurface: Color(0xFF2A313D),
    inversePrimary: Color(0xFFC4C7CA),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.canvas,
    fontFamily: 'Manrope',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.02,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.33,
        letterSpacing: -0.02,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.33,
        letterSpacing: 0.05,
      ),
    ),
  );
}
