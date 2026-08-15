import 'package:flutter/material.dart';

class AppPalette {
  const AppPalette({
    required this.canvas,
    required this.highlight,
    required this.shadow,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.activeChip,
    required this.secondary,
    required this.onSecondary,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.onTertiaryContainer,
    required this.surface,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.error,
    required this.errorContainer,
    required this.onErrorContainer,
  });

  final Color canvas;
  final Color highlight;
  final Color shadow;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color activeChip;
  final Color secondary;
  final Color onSecondary;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color onTertiaryContainer;
  final Color surface;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color error;
  final Color errorContainer;
  final Color onErrorContainer;
}

const AppPalette _lightPalette = AppPalette(
  canvas: Color(0xFFF0F2F5),
  highlight: Color(0xFFFFFFFF),
  shadow: Color(0xFFD1D9E6),
  onSurface: Color(0xFF151C27),
  onSurfaceVariant: Color(0xFF44474A),
  outline: Color(0xFF74777A),
  outlineVariant: Color(0xFFC4C7C9),
  primary: Color(0xFF5C5F61),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFF0F2F5),
  onPrimaryContainer: Color(0xFF6B6E71),
  activeChip: Color(0xFF2B2D31),
  secondary: Color(0xFF5D5E63),
  onSecondary: Color(0xFFFFFFFF),
  onSecondaryContainer: Color(0xFF616267),
  tertiary: Color(0xFF575F6A),
  onTertiary: Color(0xFFFFFFFF),
  onTertiaryContainer: Color(0xFF666E7A),
  surface: Color(0xFFF9F9FF),
  surfaceContainerLowest: Color(0xFFFFFFFF),
  surfaceContainerLow: Color(0xFFF0F3FF),
  surfaceContainer: Color(0xFFE7EEFE),
  surfaceContainerHigh: Color(0xFFE2E8F8),
  surfaceContainerHighest: Color(0xFFDCE2F3),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF93000A),
);

const AppPalette _darkPalette = AppPalette(
  canvas: Color(0xFF17191D),
  highlight: Color(0xFF24272E),
  shadow: Color(0xFF0D0F12),
  onSurface: Color(0xFFE6E9EE),
  onSurfaceVariant: Color(0xFFA2A7B0),
  outline: Color(0xFF868B93),
  outlineVariant: Color(0xFF3A3E46),
  primary: Color(0xFFBFC4CC),
  onPrimary: Color(0xFF15171B),
  primaryContainer: Color(0xFF17191D),
  onPrimaryContainer: Color(0xFFAEB4BD),
  activeChip: Color(0xFFE6E9EE),
  secondary: Color(0xFFB6BAC0),
  onSecondary: Color(0xFF15171B),
  onSecondaryContainer: Color(0xFFB8BCC3),
  tertiary: Color(0xFFAEB4BD),
  onTertiary: Color(0xFF15171B),
  onTertiaryContainer: Color(0xFFADB3BC),
  surface: Color(0xFF1D2026),
  surfaceContainerLowest: Color(0xFF121419),
  surfaceContainerLow: Color(0xFF1F232B),
  surfaceContainer: Color(0xFF262B34),
  surfaceContainerHigh: Color(0xFF2B303A),
  surfaceContainerHighest: Color(0xFF303540),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
);

abstract final class AppColors {
  static AppPalette _current = _lightPalette;

  static bool get isDark => identical(_current, _darkPalette);

  static void setDark(bool value) {
    _current = value ? _darkPalette : _lightPalette;
  }

  static Color get canvas => _current.canvas;
  static Color get highlight => _current.highlight;
  static Color get shadow => _current.shadow;
  static Color get onSurface => _current.onSurface;
  static Color get onSurfaceVariant => _current.onSurfaceVariant;
  static Color get outline => _current.outline;
  static Color get outlineVariant => _current.outlineVariant;
  static Color get primary => _current.primary;
  static Color get onPrimary => _current.onPrimary;
  static Color get primaryContainer => _current.primaryContainer;
  static Color get onPrimaryContainer => _current.onPrimaryContainer;
  static Color get activeChip => _current.activeChip;
  static Color get secondary => _current.secondary;
  static Color get onSecondary => _current.onSecondary;
  static Color get onSecondaryContainer => _current.onSecondaryContainer;
  static Color get tertiary => _current.tertiary;
  static Color get onTertiary => _current.onTertiary;
  static Color get onTertiaryContainer => _current.onTertiaryContainer;
  static Color get surface => _current.surface;
  static Color get surfaceContainerLowest => _current.surfaceContainerLowest;
  static Color get surfaceContainerLow => _current.surfaceContainerLow;
  static Color get surfaceContainer => _current.surfaceContainer;
  static Color get surfaceContainerHigh => _current.surfaceContainerHigh;
  static Color get surfaceContainerHighest => _current.surfaceContainerHighest;
  static Color get error => _current.error;
  static Color get errorContainer => _current.errorContainer;
  static Color get onErrorContainer => _current.onErrorContainer;
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
  static List<BoxShadow> get convex => [
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
  static List<BoxShadow> get concave => [
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

ThemeData buildAppTheme() => _buildTheme(Brightness.light);

ThemeData buildDarkTheme() => _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final scheme = ColorScheme(
    brightness: brightness,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.surfaceContainerLow,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.surfaceContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: brightness == Brightness.dark
        ? AppColors.onSurface
        : Colors.white,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: AppColors.shadow,
    scrim: Color(0x66000000),
    inverseSurface: brightness == Brightness.dark
        ? AppColors.surfaceContainerHighest
        : Color(0xFF2A313D),
    inversePrimary: brightness == Brightness.dark
        ? AppColors.onPrimaryContainer
        : Color(0xFFC4C7CA),
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
