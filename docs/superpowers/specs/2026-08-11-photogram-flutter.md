# Photogram Flutter App — Design

Date: 2026-08-11
Status: Approved
Stack: Flutter (no new dependencies)

## Goal

Implement the 11 Stitch "Photogram Photo Library" screens as a Flutter app
matching the "Ethereal Archive" design system, with working navigation between
them. Frontend only — no backend, no persistence, no network calls.

## Design System

- Background: `#f9f9f7` (warm off-white)
- Primary: `#030813`; primary container: `#1a202c` (deep charcoal-navy)
- On-surface: `#1a1c1b`; secondary: `#545f72` (muted slate)
- Surface containers (low→high): `#f4f4f2`, `#eeeeec`, `#e8e8e6`, `#e2e3e1`
- Outline: `#76777c`
- Font: Geist (fall back to platform default; Geist not bundled)
- Icons: Material Symbols (use built-in Material Icons, best-effort mapping)
- Shape: rounded, 16px mobile horizontal padding
- Bottom nav: 4 tabs (Library, Search, Albums, Profile) with `primary-container`
  pill highlight on the active tab.

## Structure

```
lib/
  main.dart          App entry + MaterialApp + named routes
  theme.dart         ColorScheme + ThemeData (shared tokens)
  screens/           11 screens, one file each
  components/        reusable pieces
```

### Routes

| Route          | Screen                  |
|----------------|-------------------------|
| `/welcome`     | Onboarding: Welcome     |
| `/value-prop`  | Onboarding: Value Prop  |
| `/sign-in`     | Onboarding: Sign In     |
| `/library`     | Library / Home          |
| `/search`      | Search                  |
| `/albums`      | Smart Albums            |
| `/profile`     | Profile & Settings      |
| `/event`       | Event Memory: Summer 2025 |
| `/person`      | Person: Emma            |
| `/photo`       | Photo Detail View       |
| `/settings`    | Upload / Storage Settings |

Entry point: `/welcome`. Onboarding is a linear flow (Continue / Skip buttons)
that lands on `/library`. The 4 main tabs share a bottom-nav shell; detail
screens (event, person, photo, settings) are pushed with back arrows.

### Screens

1. **Onboarding: Welcome** — app mark, headline, subtitle, "Get Started"
   button, "Skip" link, background art.
2. **Onboarding: Value Prop** — "Smart & Organized" feature highlights, next /
   back controls.
3. **Onboarding: Sign In** — email/password (or Google) sign-in form, primary
   CTA, secondary "Create account" link. Leads to `/library`.
4. **Library / Home** — top bar (settings icon, "Photogram", avatar), sticky
   section headers ("Today", "March 2026"), 2-column photo grid with check
   badge on selection, upload FAB, bottom nav (Library active).
5. **Search** — search input with mic affordance, filter chips (People,
   Screenshots, Documents, Notes, Videos), Recent Searches bento grid
   ("dog at the beach", Emma, Receipts), Content Types grid (Documents,
   ID Cards, Recipes), bottom nav (Search active).
6. **Smart Albums** — "Smart Albums" grid (People, Screenshots, Documents,
   Notes, On This Day, Trips), divider, "My Albums" (Summer 2025, Home Office)
   with add button, bottom nav (Albums active).
7. **Event Memory: Summer 2025** — back/more top bar, cover image
   (rounded-3xl), title + date range "July 15 - 22", chips (Malibu, Beach,
   Family), Memory Highlights horizontal scroll with play tile, "All Photos
   (142)" 3-column grid with "+139" tile, share FAB with bottom sheet.
8. **Person: Emma** — sticky header, circular avatar, "Emma" + edit,
   "42 Photos", "Recent" and "Last Summer" sections, one 2x1 wide tile.
9. **Photo Detail View** — immersive full-bleed dark background, custom top
   bar (back, favorite, share), centered photo, bottom gradient panel with
   date/location/people chips (Sarah, David), details chips (Pacific Northwest
   Trip, Sony A7IV • 35mm), swipe dots.
10. **Upload / Storage Settings** — back + "Upload & Storage", Storage
    Options, Photogram Storage card (active toggle), Connect Telegram card.
11. **Profile & Settings** — avatar/name header, stats, settings list,
    same bottom nav as other tabs.

### Components (`lib/components/`)

- `bottomNavShell.dart` — Scaffold wrapper with the 4-tab nav bar.
- `photoTile.dart` — placeholder photo tile (muted color block + photo icon;
  seeded palette; swap-in point for real assets later).
- `sectionHeader.dart` — sticky section headers ("Today", "March 2026").
- `chip.dart` — small label chips (filters, tags).
- `onboardingShell.dart` — shared onboarding layout scaffolding.

### Images / Placeholders

No network. `photoTile` renders a color block (picked from a small muted
palette via a stable hash of the tile id) with a Material photo icon. The
component API mirrors an asset URL so real images can replace placeholders
later without touching call sites.

### State

Static mock data per screen matching the designs (photo grid, albums, people,
storage stats, onboarding copy). No global state management added; local
`StatefulWidget` state for tab selection and basic UI toggles only.

## Tests

- Widget test for the bottom-nav shell: tapping each tab renders the matching
  screen.
- Widget test for onboarding flow: Welcome → Value Prop → Sign In → Library.
- Widget test(s) for at least one representative screen (e.g. Library renders
  section headers and FAB; Photo Detail renders dark background + chips).
- `flutter analyze` must pass; `flutter test` must pass.

## Non-Goals

- No backend / `request.txt` (frontend-only project).
- No real image assets, no network images.
- No persistence / auth logic — Sign In is a UI form only.
- No third-party dependencies beyond Flutter SDK + flutter_lints.

## Conventions

- Follow global AGENTS.md naming: PascalCase classes, camelCase
  functions/methods/variables/attributes, UPPER_SNAKE_CASE constants.
- Third-party / Flutter API names used as-is.
- No comments restating code; comments only for non-obvious decisions.
- Files: `lib/screens/{name}Screen.dart`, `lib/components/{name}.dart`.
