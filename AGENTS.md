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
