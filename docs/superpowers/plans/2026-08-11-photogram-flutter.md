# Photogram Flutter App — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the 11-screen "Photogram Photo Library" Flutter app matching the Ethereal Archive Stitch designs, with onboarding → tabbed app flow and placeholder artwork.

**Architecture:** A `MaterialApp` (`PhotogramApp`) with named routes. `theme.dart` holds all design tokens. Reusable components live in `lib/components/`, one screen per file in `lib/screens/`. Four tab screens (Library, Search, Albums, Profile) are hosted by a stateful `BottomNavShell`; detail screens (Event, Person, Photo Detail, Settings) are pushed routes. Onboarding (Welcome → Value Prop → Sign In) is the entry flow and ends at `/library`.

**Tech Stack:** Flutter 3.44.9, Dart SDK `^3.12.2`, Material 3, no new dependencies. Existing: `cupertino_icons`, `flutter_lints`. Reference designs: `/tmp/opencode/photogram/*.html` (11 Stitch HTML files). Design doc: `docs/superpowers/specs/2026-08-11-photogram-flutter.md`.

## Global Constraints

- Dart SDK `^3.12.2`, Flutter 3.44.9. Use only the existing dependencies — do not add packages.
- Naming (mandatory): PascalCase classes, camelCase functions/methods/variables, UPPER_SNAKE_CASE constants. Third-party/Flutter identifiers used exactly as-is.
- All color tokens come from `AppColors` in `lib/theme.dart` — never raw hex literals in screens/components.
- Placeholder artwork only: no network images, no asset images. Use `PlaceholderArtwork`/`PhotoTile`/`PlaceholderAvatar` seeded by a string.
- Mobile-first (max width ~400dp layouts). Desktop side nav is NOT implemented.
- Use `Color.withValues(alpha: ...)`, not the deprecated `withOpacity`.
- No comments restating code; comments only for non-obvious decisions.
- **No git commits in any task** — the project folder is not a git repository and the user has not requested git operations. End each task with `flutter analyze` + `flutter test` passing instead.
- The project starts with a default counter app in `lib/main.dart` and a default `test/widget_test.dart`. `widget_test.dart` must be rewritten (Task 13) in the same step that replaces `main.dart`, or the test suite breaks.

---

### Task 1: Project conventions + theme

**Files:**
- Create: `AGENTS.md`
- Create: `lib/theme.dart`
- Create: `test/theme_test.dart`

**Interfaces:**
- Produces: `class AppColors` (abstract final, all `static const Color` tokens listed below), `ThemeData buildAppTheme()`. All later tasks import these from `package:untitled/theme.dart`.

- [ ] **Step 1: Write the failing test**

Create `test/theme_test.dart`:

```dart
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
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/theme_test.dart`
Expected: FAIL — `lib/theme.dart` doesn't exist (`URI doesn't exist`).

- [ ] **Step 3: Write `lib/theme.dart`**

```dart
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
```

- [ ] **Step 4: Create `AGENTS.md` at the project root**

```markdown
# AGENTS.md — Photogram (Flutter)

## Project
Mobile photo-library UI app matching the "Ethereal Archive" Stitch design
system. Flutter, no extra dependencies. Frontend only; mock data; placeholder
artwork tiles.

## Conventions
- Naming: PascalCase classes, camelCase functions/methods/variables,
  UPPER_SNAKE_CASE constants. Third-party / Flutter identifiers used as-is.
- Design tokens live in `AppColors` (lib/theme.dart). Use them, not raw hex.
- Placeholder art via `PlaceholderArtwork` / `PhotoTile` / `PlaceholderAvatar`,
  seeded by a string so later asset swaps don't touch call sites.
- Files: `lib/screens/{name}Screen.dart`, `lib/components/{name}.dart`.
- No comments restating code; comment only non-obvious decisions.

## Commands
- Run: `flutter run`
- Tests: `flutter test`
- Analyze: `flutter analyze`
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `flutter test test/theme_test.dart`
Expected: PASS.

- [ ] **Step 6: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

---

### Task 2: Placeholder artwork, photo tile, avatar, chip, sticky header

**Files:**
- Create: `lib/components/placeholderArtwork.dart`
- Create: `lib/components/photoTile.dart`
- Create: `lib/components/placeholderAvatar.dart`
- Create: `lib/components/chip.dart`
- Create: `lib/components/sectionHeader.dart`
- Create: `test/components_test.dart`

**Interfaces:**
- Produces:
  - `Color placeholderColorFor(String seed)` — deterministic muted color.
  - `class PlaceholderArtwork extends StatelessWidget { const PlaceholderArtwork({Key? key, required String seed, IconData icon = Icons.photo_outlined, double iconSize = 32}); }`
  - `class PhotoTile extends StatelessWidget { const PhotoTile({Key? key, required String seed, bool selected = false, VoidCallback? onTap, BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12))}); }`
  - `class PlaceholderAvatar extends StatelessWidget { const PlaceholderAvatar({Key? key, required String seed, double size = 32}); }`
  - `class FilterChipWidget extends StatelessWidget { const FilterChipWidget({Key? key, required String label, IconData? icon, bool selected = false, VoidCallback? onTap}); }`
  - `class StickySectionHeader extends StatelessWidget { const StickySectionHeader({Key? key, required String title}); }` — returns a pinned `SliverPersistentHeader`.

- [ ] **Step 1: Write the failing test**

Create `test/components_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/components/chip.dart';
import 'package:untitled/components/photoTile.dart';
import 'package:untitled/components/placeholderArtwork.dart';
import 'package:untitled/theme.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(theme: buildAppTheme(), home: Scaffold(body: child));

  test('placeholderColorFor returns a palette color deterministically', () {
    expect(placeholderColorFor('a'), placeholderColorFor('a'));
    expect(kPlaceholderPalette, contains(placeholderColorFor('anything')));
  });

  testWidgets('PhotoTile shows a selected badge when selected', (tester) async {
    await tester.pumpWidget(wrap(const PhotoTile(seed: 'tile', selected: true)));
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.byType(PlaceholderArtwork), findsOneWidget);
  });

  testWidgets('PhotoTile without selected shows no badge', (tester) async {
    await tester.pumpWidget(wrap(const PhotoTile(seed: 'tile')));
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('FilterChipWidget renders label and icon', (tester) async {
    await tester.pumpWidget(wrap(const FilterChipWidget(label: 'People', icon: Icons.group, selected: true)));
    expect(find.text('People'), findsOneWidget);
    expect(find.byIcon(Icons.group), findsOneWidget);
  });
}
```

Note: `kPlaceholderPalette` must be a top-level exported `const List<Color>`.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/components_test.dart`
Expected: FAIL — component files don't exist.

- [ ] **Step 3: Create `lib/components/placeholderArtwork.dart`**

```dart
import 'package:flutter/material.dart';

const List<Color> kPlaceholderPalette = [
  Color(0xFFD8DAE0),
  Color(0xFFC7D3E4),
  Color(0xFFD9E1DC),
  Color(0xFFE4DAD5),
  Color(0xFFD2D8E9),
  Color(0xFFDCD4CB),
  Color(0xFFDEE3D8),
  Color(0xFFDAD5DC),
];

Color placeholderColorFor(String seed) {
  return kPlaceholderPalette[seed.hashCode.abs() % kPlaceholderPalette.length];
}

class PlaceholderArtwork extends StatelessWidget {
  const PlaceholderArtwork({
    super.key,
    required this.seed,
    this.icon = Icons.photo_outlined,
    this.iconSize = 32,
  });

  final String seed;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: placeholderColorFor(seed),
      child: Center(
        child: Icon(icon, size: iconSize, color: Colors.white.withValues(alpha: 0.85)),
      ),
    );
  }
}
```

- [ ] **Step 4: Create `lib/components/photoTile.dart`**

```dart
import 'package:flutter/material.dart';
import 'placeholderArtwork.dart';

class PhotoTile extends StatelessWidget {
  const PhotoTile({
    super.key,
    required this.seed,
    this.selected = false,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  final String seed;
  final bool selected;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PlaceholderArtwork(seed: seed),
            if (selected)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.onPrimary, width: 2),
                  ),
                  child: Icon(Icons.check, size: 16, color: scheme.onPrimary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Create `lib/components/placeholderAvatar.dart`**

```dart
import 'package:flutter/material.dart';
import 'placeholderArtwork.dart';

class PlaceholderAvatar extends StatelessWidget {
  const PlaceholderAvatar({super.key, required this.seed, this.size = 32});

  final String seed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: PlaceholderArtwork(seed: seed, icon: Icons.person, iconSize: size * 0.5),
      ),
    );
  }
}
```

- [ ] **Step 6: Create `lib/components/chip.dart`**

```dart
import 'package:flutter/material.dart';
import '../theme.dart';

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryFixed.withValues(alpha: 0.3)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: selected ? AppColors.primary : AppColors.secondary),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Create `lib/components/sectionHeader.dart`**

```dart
import 'package:flutter/material.dart';
import '../theme.dart';

class StickySectionHeader extends StatelessWidget {
  const StickySectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(pinned: true, delegate: _SectionHeaderDelegate(title));
  }
}

class _SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _SectionHeaderDelegate(this.title);

  final String title;

  @override
  double get minExtent => 40;
  @override
  double get maxExtent => 40;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background.withValues(alpha: 0.92),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.onSurface),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SectionHeaderDelegate oldDelegate) {
    return oldDelegate.title != title;
  }
}
```

- [ ] **Step 8: Run the tests to verify they pass**

Run: `flutter test test/components_test.dart`
Expected: PASS.

- [ ] **Step 9: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

---

### Task 3: App bars (tab + back)

**Files:**
- Create: `lib/components/tabAppBar.dart`
- Create: `lib/components/backAppBar.dart`
- Create: `test/appbar_test.dart`

**Interfaces:**
- Produces:
  - `class TabAppBar extends StatelessWidget implements PreferredSizeWidget` — const constructor, `preferredSize = Size.fromHeight(64)`. Left: settings icon (navigates to `/settings`). Center: "Photogram". Right: `PlaceholderAvatar(seed: 'account-avatar')`.
  - `class BackAppBar extends StatelessWidget implements PreferredSizeWidget` — const constructor `BackAppBar({String title = 'Photogram', Widget? trailing})`. Left: back arrow (`Navigator.maybePop`). Center: title. Right: `trailing` or a 48-wide spacer.

- [ ] **Step 1: Write the failing test**

Create `test/appbar_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/components/backAppBar.dart';
import 'package:untitled/components/tabAppBar.dart';
import 'package:untitled/screens/settingsScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('TabAppBar shows brand and avatar', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const Scaffold(appBar: TabAppBar(), body: SizedBox())));
    expect(find.text('Photogram'), findsOneWidget);
    expect(find.byType(PlaceholderAvatar), findsOneWidget);
  });

  testWidgets('BackAppBar shows back arrow and title', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const Scaffold(appBar: BackAppBar(title: 'Upload & Storage'), body: SizedBox())));
    expect(find.text('Upload & Storage'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}
```

Note: `test/appbar_test.dart` imports `PlaceholderAvatar` — use the exact type via `import 'package:untitled/components/placeholderAvatar.dart';`. Do not rely on `find.byType` resolving through re-exports.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/appbar_test.dart`
Expected: FAIL — `lib/components/tabAppBar.dart` and `lib/components/backAppBar.dart` don't exist. Note `lib/screens/settingsScreen.dart` does not exist yet (Task 12) — do NOT import it in this test. Remove that import from the test above before running.

- [ ] **Step 3: Create `lib/components/tabAppBar.dart`**

```dart
import 'package:flutter/material.dart';
import '../theme.dart';
import 'placeholderAvatar.dart';

class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TabAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.background.withValues(alpha: 0.85),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
            icon: const Icon(Icons.settings),
            color: AppColors.primary,
            tooltip: 'Settings',
          ),
          const Expanded(
            child: Text(
              'Photogram',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ),
          const PlaceholderAvatar(seed: 'account-avatar'),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Create `lib/components/backAppBar.dart`**

```dart
import 'package:flutter/material.dart';
import '../theme.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({super.key, this.title = 'Photogram', this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.background.withValues(alpha: 0.85),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primary,
            tooltip: 'Back',
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
            ),
          ),
          trailing ?? const SizedBox(width: 48),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Update `test/appbar_test.dart` to the final version (imports both components, no screen imports)**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/components/backAppBar.dart';
import 'package:untitled/components/placeholderAvatar.dart';
import 'package:untitled/components/tabAppBar.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('TabAppBar shows brand and avatar', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const Scaffold(appBar: TabAppBar(), body: SizedBox())));
    expect(find.text('Photogram'), findsOneWidget);
    expect(find.byType(PlaceholderAvatar), findsOneWidget);
  });

  testWidgets('BackAppBar shows back arrow and title', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const Scaffold(appBar: BackAppBar(title: 'Upload & Storage'), body: SizedBox())));
    expect(find.text('Upload & Storage'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}
```

- [ ] **Step 6: Run the tests to verify they pass**

Run: `flutter test test/appbar_test.dart`
Expected: PASS.

- [ ] **Step 7: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

---

### Task 4: Library screen

**Files:**
- Create: `lib/screens/libraryScreen.dart`
- Create: `test/libraryScreen_test.dart`

**Interfaces:**
- Produces: `class LibraryScreen extends StatelessWidget` (const). Uses `TabAppBar`, `StickySectionHeader`, `PhotoTile`. Tapping a tile pushes `/photo`; the FAB pushes `/settings`.

- [ ] **Step 1: Write the failing test**

Create `test/libraryScreen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/libraryScreen.dart';
import 'package:untitled/screens/settingsScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Library renders sections, photo grid and upload FAB', (tester) async {
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
```

Note: the second test imports `SettingsScreen`, which does not exist until Task 12. `SettingsScreen` is a trivial screen; create a temporary stub for it in this task by creating `lib/screens/settingsScreen.dart` with the **full final implementation from Task 12** now (it has no dependencies outside `BackAppBar` and `theme.dart`, which exist after Task 3). Task 12 will then only add its own test. This keeps the suite green.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/libraryScreen_test.dart`
Expected: FAIL — `lib/screens/libraryScreen.dart` doesn't exist.

- [ ] **Step 3: Create `lib/screens/libraryScreen.dart`**

```dart
import 'package:flutter/material.dart';
import '../components/photoTile.dart';
import '../components/sectionHeader.dart';
import '../components/tabAppBar.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const List<String> _todaySeeds = ['today-1', 'today-2', 'today-3'];
  static const List<String> _marchSeeds = [
    'march-1',
    'march-2',
    'march-3',
    'march-4',
    'march-5',
    'march-6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TabAppBar(),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          const StickySectionHeader(title: 'Today'),
          _photoGrid(context, _todaySeeds, selectedIndex: 0),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
          const StickySectionHeader(title: 'March 2026'),
          _photoGrid(context, _marchSeeds),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/settings'),
        tooltip: 'Upload photo',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _photoGrid(BuildContext context, List<String> seeds, {int? selectedIndex}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return PhotoTile(
              seed: seeds[index],
              selected: index == selectedIndex,
              onTap: () => Navigator.of(context).pushNamed('/photo'),
            );
          },
          childCount: seeds.length,
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Create the final `lib/screens/settingsScreen.dart` from Task 12 (copy exactly)**

```dart
import 'package:flutter/material.dart';
import '../components/backAppBar.dart';
import '../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(title: 'Upload & Storage'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Storage Options',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            const Text(
              'Choose how you want to store your memories.',
              style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            _storageCard(),
            const SizedBox(height: 16),
            _telegramCard(),
          ],
        ),
      ),
    );
  }

  Widget _storageCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                child: const Icon(Icons.cloud_done, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Use Photogram Storage',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Recommended',
                        style: TextStyle(fontSize: 12, color: AppColors.onSecondaryContainer),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Fast, secure, and ready to use. Optimized for your media library.',
                      style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _toggle(on: true),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Active',
              style: TextStyle(fontSize: 14, color: AppColors.primary.withValues(alpha: 0.8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _telegramCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: AppColors.surfaceContainerHigh, shape: BoxShape.circle),
                child: const Icon(Icons.forum, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connect my own Telegram',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Use your own Telegram group or channel for unlimited private storage.',
                      style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _toggle(on: false),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Connect'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggle({required bool on}) {
    return Container(
      width: 44,
      height: 24,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: on ? AppColors.primary : AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: on ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: on ? Colors.white : AppColors.outline, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Run the tests to verify they pass**

Run: `flutter test test/libraryScreen_test.dart`
Expected: PASS (both tests).

- [ ] **Step 6: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

---

### Task 5: Search screen

**Files:**
- Create: `lib/screens/searchScreen.dart`
- Create: `test/searchScreen_test.dart`

**Interfaces:**
- Produces: `class SearchScreen extends StatelessWidget` (const). Uses `TabAppBar`, `FilterChipWidget`.

- [ ] **Step 1: Write the failing test**

Create `test/searchScreen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/searchScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Search renders input, chips, recent searches and content types', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const SearchScreen()));
    expect(find.text('Recent Searches'), findsOneWidget);
    expect(find.text('Content Types'), findsOneWidget);
    expect(find.text('Screenshots'), findsOneWidget);
    expect(find.text('"dog at the beach"'), findsOneWidget);
    expect(find.text('ID Cards'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/searchScreen_test.dart`
Expected: FAIL — `lib/screens/searchScreen.dart` doesn't exist.

- [ ] **Step 3: Create `lib/screens/searchScreen.dart`**

```dart
import 'package:flutter/material.dart';
import '../components/chip.dart';
import '../components/placeholderArtwork.dart';
import '../components/tabAppBar.dart';
import '../theme.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TabAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchField(context),
            const SizedBox(height: 16),
            _filterChips(),
            const SizedBox(height: 32),
            const Text(
              'Recent Searches',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.onSurface),
            ),
            const SizedBox(height: 12),
            _recentSearches(),
            const SizedBox(height: 32),
            const Text(
              'Content Types',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.onSurface),
            ),
            const SizedBox(height: 12),
            _contentTypes(),
          ],
        ),
      ),
    );
  }

  Widget _searchField(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search, color: scheme.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              key: const Key('searchField'),
              decoration: const InputDecoration(
                hintText: "Search your photos... 'dog at the beach', 'receipt from March', a person's name",
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              style: const TextStyle(fontSize: 18, color: AppColors.onSurface),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.mic, color: scheme.secondary),
            tooltip: 'Voice search',
          ),
        ],
      ),
    );
  }

  Widget _filterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          FilterChipWidget(label: 'People', icon: Icons.group, selected: true),
          SizedBox(width: 8),
          FilterChipWidget(label: 'Screenshots', icon: Icons.screenshot),
          SizedBox(width: 8),
          FilterChipWidget(label: 'Documents', icon: Icons.description),
          SizedBox(width: 8),
          FilterChipWidget(label: 'Notes', icon: Icons.notes),
          SizedBox(width: 8),
          FilterChipWidget(label: 'Videos', icon: Icons.movie),
        ],
      ),
    );
  }

  Widget _recentSearches() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              const SizedBox(
                height: 160,
                width: double.infinity,
                child: PlaceholderArtwork(seed: 'dog-at-the-beach', icon: Icons.pets, iconSize: 48),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.primary.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '"dog at the beach"',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    SizedBox(height: 2),
                    Text('Found in Summer 2023', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 120,
                  color: AppColors.surfaceContainerLow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long, color: AppColors.primary),
                      const SizedBox(height: 4),
                      const Text('Receipts', style: TextStyle(fontSize: 12, color: AppColors.onSurface)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    const SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: PlaceholderArtwork(seed: 'emma-search', icon: Icons.person, iconSize: 40),
                    ),
                    const Positioned(
                      left: 8,
                      bottom: 8,
                      child: Text('Emma', style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _contentTypes() {
    const items = [
      (Icons.article, 'Documents'),
      (Icons.id_card, 'ID Cards'),
      (Icons.restaurant_menu, 'Recipes'),
    ];
    return Row(
      children: [
        for (final (icon, label) in items) ...[
          Expanded(
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.secondaryContainer, shape: BoxShape.circle),
                    child: Icon(icon, size: 20, color: AppColors.onSecondaryContainer),
                  ),
                  const SizedBox(height: 6),
                  Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/searchScreen_test.dart`
Expected: PASS.

- [ ] **Step 5: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

---

### Task 6: Albums screen

**Files:**
- Create: `lib/screens/albumsScreen.dart`
- Create: `test/albumsScreen_test.dart`

**Interfaces:**
- Produces: `class AlbumsScreen extends StatelessWidget` (const). Uses `TabAppBar`, `PlaceholderArtwork`.

- [ ] **Step 1: Write the failing test**

Create `test/albumsScreen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/albumsScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Albums renders smart and my albums', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const AlbumsScreen()));
    expect(find.text('Smart Albums'), findsOneWidget);
    expect(find.text('My Albums'), findsOneWidget);
    expect(find.text('People'), findsOneWidget);
    expect(find.text('248 photos'), findsOneWidget);
    expect(find.text('Summer 2025'), findsOneWidget);
    expect(find.text('124 items'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/albumsScreen_test.dart`
Expected: FAIL — `lib/screens/albumsScreen.dart` doesn't exist.

- [ ] **Step 3: Create `lib/screens/albumsScreen.dart`**

```dart
import 'package:flutter/material.dart';
import '../components/placeholderArtwork.dart';
import '../components/tabAppBar.dart';
import '../theme.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TabAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Albums',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.onSurface),
            ),
            const SizedBox(height: 16),
            _smartAlbumsGrid(),
            const SizedBox(height: 24),
            Divider(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'My Albums',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.onSurface),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  color: AppColors.primary,
                  tooltip: 'New album',
                ),
              ],
            ),
            const SizedBox(height: 8),
            _myAlbumsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _smartAlbumsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _albumCard('People', '248 photos', icon: Icons.person, isPeopleGrid: true)),
            const SizedBox(width: 16),
            Expanded(child: _albumCard('Screenshots', '112 items', icon: Icons.screenshot)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _albumCard('Documents', '45 items', icon: Icons.description)),
            const SizedBox(width: 16),
            Expanded(child: _albumCard('Notes', '18 items', icon: Icons.notes)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _albumCard('On This Day', '3 years ago', icon: Icons.calendar_month, imageSeed: 'on-this-day')),
            const SizedBox(width: 16),
            Expanded(child: _albumCard('Trips', '864 photos', icon: Icons.flight, imageSeed: 'trips')),
          ],
        ),
      ],
    );
  }

  Widget _myAlbumsGrid() {
    return Row(
      children: [
        Expanded(child: _albumCard('Summer 2025', '124 items', icon: Icons.beach_access, imageSeed: 'summer-2025')),
        const SizedBox(width: 16),
        Expanded(child: _albumCard('Home Office', '32 items', icon: Icons.home_work, imageSeed: 'home-office')),
      ],
    );
  }

  Widget _albumCard(
    String title,
    String count, {
    required IconData icon,
    bool isPeopleGrid = false,
    String? imageSeed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: imageSeed != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      PlaceholderArtwork(seed: imageSeed, icon: icon, iconSize: 40),
                      ColoredBox(color: Colors.black.withValues(alpha: 0.25)),
                      Center(child: Icon(icon, size: 32, color: Colors.white)),
                    ],
                  )
                : isPeopleGrid
                    ? _peopleArtwork()
                    : Container(
                        color: AppColors.surfaceContainer,
                        child: Icon(icon, size: 40, color: AppColors.secondary),
                      ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(count, style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
      ],
    );
  }

  Widget _peopleArtwork() {
    return Container(
      color: AppColors.surfaceContainer,
      padding: const EdgeInsets.all(4),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < 4; i++)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: PlaceholderArtwork(seed: 'people-$i', icon: Icons.person, iconSize: 20),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/albumsScreen_test.dart`
Expected: PASS.

- [ ] **Step 5: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

---

### Task 7: Profile screen

**Files:**
- Create: `lib/screens/profileScreen.dart`
- Create: `test/profileScreen_test.dart`

**Interfaces:**
- Produces: `class ProfileScreen extends StatelessWidget` (const). Header "Profile" + settings icon (pushes `/settings`). Uses `PlaceholderAvatar`.

- [ ] **Step 1: Write the failing test**

Create `test/profileScreen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/profileScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Profile renders identity, storage, accounts and settings', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const ProfileScreen()));
    expect(find.text('Sarah Jenkins'), findsOneWidget);
    expect(find.text('@sjenkins'), findsOneWidget);
    expect(find.text('Connected Accounts'), findsOneWidget);
    expect(find.text('People'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/profileScreen_test.dart`
Expected: FAIL — `lib/screens/profileScreen.dart` doesn't exist.

- [ ] **Step 3: Create `lib/screens/profileScreen.dart`**

```dart
import 'package:flutter/material.dart';
import '../components/placeholderAvatar.dart';
import '../theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: AppColors.background.withValues(alpha: 0.85),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed('/settings'),
                icon: const Icon(Icons.settings),
                color: AppColors.secondary,
                tooltip: 'Settings',
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _profileHeader(),
          const SizedBox(height: 24),
          _storageCard(context),
          const SizedBox(height: 24),
          const Text(
            'Connected Accounts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          _accountsCard(),
          const SizedBox(height: 24),
          _peopleSection(),
          const SizedBox(height: 24),
          _settingsList(),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Sign Out', style: TextStyle(fontSize: 14, color: AppColors.secondary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            const PlaceholderAvatar(seed: 'sarah', size: 96),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Sarah Jenkins',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
        ),
        const SizedBox(height: 2),
        const Text('@sjenkins', style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _storageCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.cloud_done, size: 20, color: AppColors.success),
              SizedBox(width: 8),
              Text(
                'Photogram Storage',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 6,
              color: AppColors.surfaceContainer,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 2 / 3,
                child: Container(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '12.4 GB backed up · 3,204 items',
            style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/settings'),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.surfaceContainerLow,
                foregroundColor: AppColors.primary,
              ),
              child: const Text('Manage storage'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          _accountRow(icon: Icons.send, iconBg: const Color(0xFFE3F2FD), iconColor: const Color(0xFF1E88E5), name: 'Telegram', connected: true),
          Divider(height: 1, color: AppColors.surfaceContainer),
          _accountRow(icon: Icons.calendar_today, iconBg: const Color(0xFFE8F5E9), iconColor: const Color(0xFF43A047), name: 'Google Calendar', connected: true),
          Divider(height: 1, color: AppColors.surfaceContainer),
          _accountRow(icon: Icons.photo, iconBg: AppColors.surfaceContainer, iconColor: AppColors.onSurfaceVariant, name: 'Google Photos', connected: false),
        ],
      ),
    );
  }

  Widget _accountRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String name,
    required bool connected,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, color: AppColors.primary)),
                const SizedBox(height: 2),
                if (connected)
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                      ),
                      const Text('Connected', style: TextStyle(fontSize: 12, color: AppColors.success)),
                    ],
                  )
                else
                  const Text('Not connected', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          if (!connected)
            TextButton(
              onPressed: () {},
              child: const Text('Connect'),
            ),
        ],
      ),
    );
  }

  Widget _peopleSection() {
    const names = ['Emma', 'David', 'Sarah', 'Mom'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'People',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text('Manage', style: TextStyle(fontSize: 14, color: AppColors.secondary)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < names.length; i++) ...[
                Column(
                  children: [
                    PlaceholderAvatar(seed: names[i].toLowerCase(), size: 64),
                    const SizedBox(height: 6),
                    Text(names[i], style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                  ],
                ),
                if (i < names.length - 1) const SizedBox(width: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingsList() {
    final rows = <(IconData, String, String?)>[
      (Icons.notifications, 'Notifications', null),
      (Icons.shield, 'Privacy & Sharing', null),
      (Icons.backup, 'Backup', 'Wi-Fi only'),
      (Icons.storage, 'Storage & data', null),
      (Icons.help, 'Help & support', null),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _settingsRow(icon: rows[i].$1, label: rows[i].$2, detail: rows[i].$3),
            if (i < rows.length - 1) Divider(height: 1, color: AppColors.surfaceContainer),
          ],
        ],
      ),
    );
  }

  Widget _settingsRow({required IconData icon, required String label, String? detail}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.secondary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 16, color: AppColors.primary)),
          ),
          if (detail != null)
            Text(detail, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
          if (detail == 'Wi-Fi only') ...[
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 24,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Align(
                alignment: Alignment.centerRight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: SizedBox(width: 20, height: 20),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.onSurfaceVariant),
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/profileScreen_test.dart`
Expected: PASS.

- [ ] **Step 5: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

---

### Task 8: Bottom nav shell

**Files:**
- Create: `lib/components/bottomNavShell.dart`
- Create: `test/bottomNavShell_test.dart`

**Interfaces:**
- Produces: `class BottomNavShell extends StatefulWidget { const BottomNavShell({super.key, int initialIndex = 0}); }`. Hosts `IndexedStack` of `[LibraryScreen(), SearchScreen(), AlbumsScreen(), ProfileScreen()]` and a custom 4-item bottom nav bar. The nav bar `Container` carries `key: const Key('bottomNav')`.

- [ ] **Step 1: Write the failing test**

Create `test/bottomNavShell_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/components/bottomNavShell.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('bottom nav switches between the four tabs', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const BottomNavShell()));

    expect(find.text('Today'), findsOneWidget);

    await tester.tap(find.descendant(of: find.byKey(const Key('bottomNav')), matching: find.text('Search')));
    await tester.pumpAndSettle();
    expect(find.text('Recent Searches'), findsOneWidget);

    await tester.tap(find.descendant(of: find.byKey(const Key('bottomNav')), matching: find.text('Albums')));
    await tester.pumpAndSettle();
    expect(find.text('Smart Albums'), findsOneWidget);

    await tester.tap(find.descendant(of: find.byKey(const Key('bottomNav')), matching: find.text('Profile')));
    await tester.pumpAndSettle();
    expect(find.text('Sarah Jenkins'), findsOneWidget);
  });

  testWidgets('initialIndex starts on the requested tab', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const BottomNavShell(initialIndex: 2)));
    expect(find.text('Smart Albums'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/bottomNavShell_test.dart`
Expected: FAIL — `lib/components/bottomNavShell.dart` doesn't exist.

- [ ] **Step 3: Create `lib/components/bottomNavShell.dart`**

```dart
import 'package:flutter/material.dart';
import '../screens/albumsScreen.dart';
import '../screens/libraryScreen.dart';
import '../screens/profileScreen.dart';
import '../screens/searchScreen.dart';
import '../theme.dart';

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  static const List<Widget> _tabs = [
    LibraryScreen(),
    SearchScreen(),
    AlbumsScreen(),
    ProfileScreen(),
  ];
  static const List<IconData> _icons = [
    Icons.photo_library,
    Icons.search,
    Icons.auto_stories,
    Icons.person,
  ];
  static const List<String> _labels = ['Library', 'Search', 'Albums', 'Profile'];

  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      key: const Key('bottomNav'),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.92),
        border: Border(top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [for (var i = 0; i < 4; i++) _navItem(i)],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index) {
    final selected = index == _index;
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _index = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _icons[index],
              size: 24,
              fill: selected ? 1 : 0,
              color: selected ? scheme.primary : scheme.secondary,
            ),
            const SizedBox(height: 2),
            Text(
              _labels[index],
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? scheme.primary : scheme.secondary,
              ),
            ),
            Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: selected ? scheme.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/bottomNavShell_test.dart`
Expected: PASS (both tests).

- [ ] **Step 5: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

---

### Task 9: Event Memory screen

**Files:**
- Create: `lib/screens/eventScreen.dart`
- Create: `test/eventScreen_test.dart`

**Interfaces:**
- Produces: `class EventScreen extends StatelessWidget` (const). Uses `BackAppBar` (trailing `more_vert`), `PlaceholderArtwork`. Share FAB opens a `showModalBottomSheet` titled "Share Memory".

- [ ] **Step 1: Write the failing test**

Create `test/eventScreen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/eventScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Event renders memory content and opens the share sheet', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const EventScreen()));
    expect(find.text('Summer 2025'), findsOneWidget);
    expect(find.text('Memory Highlights'), findsOneWidget);
    expect(find.text('All Photos (142)'), findsOneWidget);
    expect(find.text('+139'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Share Memory'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/eventScreen_test.dart`
Expected: FAIL — `lib/screens/eventScreen.dart` doesn't exist.

- [ ] **Step 3: Create `lib/screens/eventScreen.dart`**

```dart
import 'package:flutter/material.dart';
import '../components/backAppBar.dart';
import '../components/placeholderArtwork.dart';
import '../theme.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
          color: AppColors.primary,
          tooltip: 'More',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openShareSheet(context),
        tooltip: 'Share memory',
        child: const Icon(Icons.ios_share),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        child: Column(
          children: [
            _cover(),
            const SizedBox(height: 16),
            const Text(
              'Summer 2025',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            const Text('July 15 - 22', style: TextStyle(fontSize: 16, color: AppColors.secondary)),
            const SizedBox(height: 12),
            _tagChips(),
            const SizedBox(height: 32),
            const Text(
              'Memory Highlights',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            _highlights(),
            const SizedBox(height: 32),
            const Text(
              'All Photos (142)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            _photoGrid(),
          ],
        ),
      ),
    );
  }

  Widget _cover() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: const SizedBox(
        height: 288,
        width: double.infinity,
        child: PlaceholderArtwork(seed: 'event-cover', icon: Icons.beach_access, iconSize: 72),
      ),
    );
  }

  Widget _tagChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final tag in const ['Malibu', 'Beach', 'Family']) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              tag,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _highlights() {
    return SizedBox(
      height: 256,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _highlightTile('highlight-1', Icons.local_drink, showPlay: false),
          const SizedBox(width: 12),
          _highlightTile('highlight-2', Icons.pets, showPlay: true),
          const SizedBox(width: 12),
          _highlightTile('highlight-3', Icons.local_fire_department, showPlay: false),
        ],
      ),
    );
  }

  Widget _highlightTile(String seed, IconData icon, {required bool showPlay}) {
    return SizedBox(
      width: 192,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PlaceholderArtwork(seed: seed, icon: icon, iconSize: 48),
            if (showPlay)
              Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: AppColors.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _photoGrid() {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const AspectRatio(
              aspectRatio: 1,
              child: PlaceholderArtwork(seed: 'grid-1', icon: Icons.wb_sunny_outlined),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const AspectRatio(
              aspectRatio: 1,
              child: PlaceholderArtwork(seed: 'grid-2', icon: Icons.umbrella_outlined),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: AppColors.surfaceContainerHigh,
              alignment: Alignment.center,
              child: const Text(
                '+139',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.secondary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openShareSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white.withValues(alpha: 0.92),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(999)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Share Memory',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ShareOption(icon: Icons.groups, label: 'Photogram'),
                  _ShareOption(icon: Icons.send, label: 'Telegram'),
                  _ShareOption(icon: Icons.chat, label: 'WhatsApp'),
                  _ShareOption(icon: Icons.mail, label: 'Email'),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainerHigh,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShareOption extends StatelessWidget {
  const _ShareOption({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceVariant),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
      ],
    );
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/eventScreen_test.dart`
Expected: PASS.

- [ ] **Step 5: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

---

### Task 10: Person screen

**Files:**
- Create: `lib/screens/personScreen.dart`
- Create: `test/personScreen_test.dart`

**Interfaces:**
- Produces: `class PersonScreen extends StatelessWidget` (const). Uses `PlaceholderAvatar`, `PhotoTile`, `StickySectionHeader`. Back arrow calls `Navigator.maybePop`; tiles push `/photo`.

- [ ] **Step 1: Write the failing test**

Create `test/personScreen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/screens/personScreen.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('Person renders profile header and photo sections', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const PersonScreen()));
    expect(find.text('Emma'), findsOneWidget);
    expect(find.text('42 Photos'), findsOneWidget);
    expect(find.text('Recent'), findsOneWidget);
    expect(find.text('Last Summer'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/personScreen_test.dart`
Expected: FAIL — `lib/screens/personScreen.dart` doesn't exist.

- [ ] **Step 3: Create `lib/screens/personScreen.dart`**

```dart
import 'package:flutter/material.dart';
import '../components/placeholderAvatar.dart';
import '../components/photoTile.dart';
import '../components/sectionHeader.dart';
import '../theme.dart';

class PersonScreen extends StatelessWidget {
  const PersonScreen({super.key});

  static const List<String> _recentSeeds = ['recent-1', 'recent-2', 'recent-3', 'recent-4'];
  static const List<String> _lastSummerSeeds = ['summer-1', 'summer-2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _header(context)),
          const StickySectionHeader(title: 'Recent'),
          _grid(context, _recentSeeds),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
          const StickySectionHeader(title: 'Last Summer'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AspectRatio(
                aspectRatio: 2 / 1,
                child: PhotoTile(
                  seed: 'last-summer-wide',
                  onTap: () => Navigator.of(context).pushNamed('/photo'),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 4)),
          _grid(context, _lastSummerSeeds),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back),
                color: AppColors.onSurface,
                tooltip: 'Back',
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
          const PlaceholderAvatar(seed: 'emma', size: 128),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Emma',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600, color: AppColors.onSurface),
              ),
              SizedBox(width: 8),
              Icon(Icons.edit, size: 18, color: AppColors.secondary),
            ],
          ),
          const SizedBox(height: 8),
          const Text('42 Photos', style: TextStyle(fontSize: 16, color: AppColors.secondary)),
        ],
      ),
    );
  }

  Widget _grid(BuildContext context, List<String> seeds) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => PhotoTile(
            seed: seeds[index],
            onTap: () => Navigator.of(context).pushNamed('/photo'),
          ),
          childCount: seeds.length,
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/personScreen_test.dart`
Expected: PASS.

- [ ] **Step 5: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

---

### Task 11: Photo Detail screen

**Files:**
- Create: `lib/screens/photoDetailScreen.dart`
- Create: `test/photoDetailScreen_test.dart`

**Interfaces:**
- Produces: `class PhotoDetailScreen extends StatelessWidget` (const). Dark immersive screen (`Scaffold.backgroundColor = AppColors.primary`), uses `PlaceholderArtwork`.

- [ ] **Step 1: Write the failing test**

Create `test/photoDetailScreen_test.dart`:

```dart
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
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/photoDetailScreen_test.dart`
Expected: FAIL — `lib/screens/photoDetailScreen.dart` doesn't exist.

- [ ] **Step 3: Create `lib/screens/photoDetailScreen.dart`**

```dart
import 'package:flutter/material.dart';
import '../components/placeholderArtwork.dart';
import '../theme.dart';

class PhotoDetailScreen extends StatelessWidget {
  const PhotoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const PlaceholderArtwork(seed: 'photo-detail', icon: Icons.photo_outlined, iconSize: 120),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _topBar(context),
                const SizedBox(height: 32),
                const Expanded(child: SizedBox()),
                _bottomPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _roundButton(Icons.arrow_back, () => Navigator.of(context).maybePop(), 'Go back'),
          Row(
            children: [
              _roundButton(Icons.favorite, () {}, 'Favorite'),
              const SizedBox(width: 12),
              _roundButton(Icons.ios_share, () {}, 'Share'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap, String tooltip) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _bottomPanel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'October 24, 2023',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.white70),
              SizedBox(width: 4),
              Text('Mount Rainier National Park', style: TextStyle(fontSize: 16, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('PEOPLE', style: TextStyle(fontSize: 12, letterSpacing: 1.2, color: Colors.white70)),
          const SizedBox(height: 8),
          const Row(
            children: [
              _PersonChip(name: 'Sarah', seed: 'chip-sarah'),
              SizedBox(width: 8),
              _PersonChip(name: 'David', seed: 'chip-david'),
            ],
          ),
          const SizedBox(height: 16),
          const Text('DETAILS', style: TextStyle(fontSize: 12, letterSpacing: 1.2, color: Colors.white70)),
          const SizedBox(height: 8),
          const _DetailChip(icon: Icons.photo_album, label: 'Pacific Northwest Trip'),
          const SizedBox(height: 8),
          const _DetailChip(icon: Icons.camera, label: 'Sony A7IV • 35mm'),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 4; i++)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == 1 ? Colors.white : Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PersonChip extends StatelessWidget {
  const _PersonChip({required this.name, required this.seed});

  final String name;
  final String seed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: SizedBox(
              width: 24,
              height: 24,
              child: PlaceholderArtwork(seed: seed, icon: Icons.person, iconSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/photoDetailScreen_test.dart`
Expected: PASS.

- [ ] **Step 5: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

---

### Task 12: Settings screen test (screen already created in Task 4)

**Files:**
- Test: `test/settingsScreen_test.dart`

**Interfaces:**
- Consumes: `SettingsScreen` from `lib/screens/settingsScreen.dart` (created in Task 4, Step 4).

- [ ] **Step 1: Write the test**

Create `test/settingsScreen_test.dart`:

```dart
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
```

- [ ] **Step 2: Run the test to verify it passes**

Run: `flutter test test/settingsScreen_test.dart`
Expected: PASS.

- [ ] **Step 3: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

---

### Task 13: Onboarding screens + app entry + full suite

**Files:**
- Create: `lib/components/onboardingShell.dart`
- Create: `lib/screens/welcomeScreen.dart`
- Create: `lib/screens/valuePropScreen.dart`
- Create: `lib/screens/signInScreen.dart`
- Rewrite: `lib/main.dart`
- Rewrite: `test/widget_test.dart`

**Interfaces:**
- Produces: `class OnboardingDots extends StatelessWidget { const OnboardingDots({super.key, required int activeIndex}); }` (3 dots; the active one is a wide 32px pill).
- Produces: `class PhotogramApp extends StatelessWidget` — `MaterialApp` with `initialRoute: '/welcome'` and the 11 routes.
- Produces: `class WelcomeScreen` (Get Started → `/value-prop`), `class ValuePropScreen` (Skip → `/library`, Next → `/sign-in`), `class SignInScreen` (CTA → `/library`).
- Consumes: all screens + `BottomNavShell` + `OnboardingDots`.

- [ ] **Step 1: Write the failing tests (rewrite `test/widget_test.dart`)**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/main.dart';

void main() {
  testWidgets('onboarding flow leads to the library tab', (tester) async {
    await tester.pumpWidget(const PhotogramApp());
    await tester.pumpAndSettle();

    expect(find.text('Your memories,\nbeautifully archived.'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Smart & Organized.'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Ready to begin?'), findsOneWidget);

    await tester.tap(find.text('Sign in with Telegram'));
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsOneWidget);
  });

  testWidgets('value prop Skip jumps straight to the library', (tester) async {
    await tester.pumpWidget(const PhotogramApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/widget_test.dart`
Expected: FAIL — old `main.dart` still has the counter app (no `PhotogramApp`, no `/welcome` route).

- [ ] **Step 3: Create `lib/components/onboardingShell.dart`**

```dart
import 'package:flutter/material.dart';
import '../theme.dart';

class OnboardingDots extends StatelessWidget {
  const OnboardingDots({super.key, required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++)
          Container(
            width: i == activeIndex ? 32 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: i == activeIndex ? AppColors.primary : AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}
```

- [ ] **Step 4: Create `lib/screens/welcomeScreen.dart`**

```dart
import 'package:flutter/material.dart';
import '../components/placeholderArtwork.dart';
import '../theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const PlaceholderArtwork(seed: 'welcome-hero', icon: Icons.landscape, iconSize: 96),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background.withValues(alpha: 0.4),
                  AppColors.background,
                ],
                stops: const [0, 0.5, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Your memories,\nbeautifully archived.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      height: 56 / 48,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.02,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Private, secure, and seamlessly powered by your Telegram storage.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, height: 28 / 18, color: AppColors.secondary),
                  ),
                  const SizedBox(height: 48),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pushNamed('/value-prop'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const StadiumBorder(),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Get Started'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Create `lib/screens/valuePropScreen.dart`**

```dart
import 'package:flutter/material.dart';
import '../components/onboardingShell.dart';
import '../components/placeholderArtwork.dart';
import '../theme.dart';

class ValuePropScreen extends StatelessWidget {
  const ValuePropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: _illustration(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Smart & Organized.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Automatic face detection, smart albums, and effortless search to find any moment in seconds.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: AppColors.secondary),
                      ),
                    ),
                  ],
                ),
              ),
              const OnboardingDots(activeIndex: 1),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil('/library', (route) => false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const StadiumBorder(),
                        foregroundColor: AppColors.secondary,
                        side: BorderSide.none,
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pushNamed('/sign-in'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _illustration() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: const PlaceholderArtwork(seed: 'value-prop-hero', icon: Icons.photo_library_outlined, iconSize: 64),
            ),
          ),
          Positioned(
            top: 24,
            left: 24,
            child: _pill(icon: Icons.face, label: 'Faces identified'),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: _pill(icon: Icons.location_on, label: 'Paris, France'),
          ),
        ],
      ),
    );
  }

  Widget _pill({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.surfaceContainer),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.onSurface)),
        ],
      ),
    );
  }
}
```

- [ ] **Step 6: Create `lib/screens/signInScreen.dart`**

```dart
import 'package:flutter/material.dart';
import '../components/onboardingShell.dart';
import '../components/placeholderArtwork.dart';
import '../theme.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Photogram',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: const SizedBox(
                        width: 192,
                        height: 192,
                        child: PlaceholderArtwork(seed: 'signin-hero', icon: Icons.camera_alt_outlined, iconSize: 64),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ready to begin?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.02,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Sign in with your Telegram account to sync your library across all your devices seamlessly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil('/library', (route) => false),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(56),
                        shape: const StadiumBorder(),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.send),
                          SizedBox(width: 8),
                          Text('Sign in with Telegram'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Learn more about storage'),
                          Icon(Icons.chevron_right, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const OnboardingDots(activeIndex: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Rewrite `lib/main.dart`**

```dart
import 'package:flutter/material.dart';
import 'components/bottomNavShell.dart';
import 'screens/albumsScreen.dart';
import 'screens/eventScreen.dart';
import 'screens/libraryScreen.dart';
import 'screens/personScreen.dart';
import 'screens/photoDetailScreen.dart';
import 'screens/profileScreen.dart';
import 'screens/searchScreen.dart';
import 'screens/settingsScreen.dart';
import 'screens/signInScreen.dart';
import 'screens/valuePropScreen.dart';
import 'screens/welcomeScreen.dart';
import 'theme.dart';

void main() {
  runApp(const PhotogramApp());
}

class PhotogramApp extends StatelessWidget {
  const PhotogramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photogram',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (_) => const WelcomeScreen(),
        '/value-prop': (_) => const ValuePropScreen(),
        '/sign-in': (_) => const SignInScreen(),
        '/library': (_) => const BottomNavShell(initialIndex: 0),
        '/search': (_) => const BottomNavShell(initialIndex: 1),
        '/albums': (_) => const BottomNavShell(initialIndex: 2),
        '/profile': (_) => const BottomNavShell(initialIndex: 3),
        '/event': (_) => const EventScreen(),
        '/person': (_) => const PersonScreen(),
        '/photo': (_) => const PhotoDetailScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
```

- [ ] **Step 8: Run the full test suite**

Run: `flutter test`
Expected: ALL tests pass (theme, components, appbar, library, search, albums, profile, bottomNavShell, event, person, photoDetail, settings, widget/onboarding).

- [ ] **Step 9: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 10: Manual smoke check (optional)**

Run: `flutter run -d linux` (or the available device). Expected: app opens on Onboarding: Welcome; "Get Started" → Value Prop → "Next" → Sign In → "Sign in with Telegram" → Library tab; bottom nav switches tabs; Library FAB opens Upload & Storage; Event/Person/Photo Detail render correctly from any pushed path.

---

## Self-Review Notes

- **Spec coverage:** every screen in the design doc maps to a task (Welcome/Value Prop/Sign In → Task 13; Library → 4; Search → 5; Albums → 6; Profile → 7; shell → 8; Event → 9; Person → 10; Photo Detail → 11; Settings → 4+12). Theme/components → Tasks 1-3. Tests exist for the shell, onboarding flow, and every screen.
- **Placeholders:** none — every file is fully written inline.
- **Type consistency:** `AppColors` tokens, `PlaceholderArtwork(seed:, icon:, iconSize:)`, `PhotoTile(seed:, selected:, onTap:, borderRadius:)`, `PlaceholderAvatar(seed:, size:)`, `FilterChipWidget(label:, icon:, selected:, onTap:)`, `StickySectionHeader(title:)`, `TabAppBar()`, `BackAppBar(title:, trailing:)`, `BottomNavShell(initialIndex:)`, `OnboardingDots(activeIndex:)` are used identically everywhere.
- **Known intentional simplifications:** desktop side nav omitted (mobile-first); person.html shows a bottom nav in the reference but Person is treated as a pushed sub-page (consistent with Event/Detail/Settings, which all suppress the nav); sticky headers implemented via pinned slivers; `settings_heart` icon replaced with `settings` (not in Flutter's icon set).
