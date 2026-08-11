import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/theme.dart';

void main() {
  test('buildAppTheme uses the Ethereal Archive tokens', () {
    final theme = buildAppTheme();
    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.colorScheme.secondary, AppColors.secondary);
    expect(theme.colorScheme.onSurface, AppColors.onSurface);
  });
}
