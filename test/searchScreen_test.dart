import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/components/filterPill.dart';
import 'package:photogram/components/mosaicGrid.dart';
import 'package:photogram/components/neumorphic.dart';
import 'package:photogram/components/photoTile.dart';
import 'package:photogram/screens/searchScreen.dart';
import 'package:photogram/screens/profileScreen.dart';
import 'package:photogram/theme.dart';

import 'helpers.dart';

void main() {
  Future<void> pumpSearch(WidgetTester tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const SearchScreen()),
    );
    await tester.pumpAndSettle();
  }

  FilterPill pillByLabel(WidgetTester tester, String label) => tester
      .widgetList<FilterPill>(find.byType(FilterPill))
      .firstWhere((pill) => pill.label == label);

  testWidgets('renders search bar, filters, Recent section and photo grid',
      (tester) async {
    await pumpSearch(tester);

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(FilterPill), findsNWidgets(5));
    expect(find.text('People'), findsOneWidget);
    expect(find.text('Screenshots'), findsOneWidget);
    expect(find.text('Documents'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Videos'), findsOneWidget);
    expect(find.text('Recent'), findsOneWidget);
    expect(find.text('11'), findsOneWidget);
    expect(find.byType(PhotoTile), findsNWidgets(11));
  });

  testWidgets('no filter is active by default and all photos are shown',
      (tester) async {
    await pumpSearch(tester);

    expect(find.byType(FilterPill), findsNWidgets(5));
    for (final pill in tester.widgetList<FilterPill>(find.byType(FilterPill))) {
      expect(pill.selected, isFalse, reason: '${pill.label} is selected');
    }
  });

  testWidgets('active chip uses the dark fill and is not concave',
      (tester) async {
    await pumpSearch(tester);

    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();

    Neumorphic pillSurface(WidgetTester t, FilterPill pill) => t.widget<Neumorphic>(
          find.descendant(
            of: find.byWidget(pill),
            matching: find.byType(Neumorphic),
          ),
        );

    final activePill = pillByLabel(tester, 'People');
    final inactivePill = pillByLabel(tester, 'Screenshots');

    expect(activePill.selected, isTrue);
    expect(pillSurface(tester, activePill).variant, NeumorphicVariant.flat);
    expect(pillSurface(tester, activePill).color, AppColors.activeChip);
    expect(pillSurface(tester, inactivePill).variant, NeumorphicVariant.convex);
    expect(pillSurface(tester, inactivePill).color, AppColors.primaryContainer);
  });

  testWidgets('tapping a filter narrows the grid; tapping again resets',
      (tester) async {
    await pumpSearch(tester);

    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();

    expect(pillByLabel(tester, 'People').selected, isTrue);
    expect(find.byType(PhotoTile), findsNWidgets(2));
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();

    expect(pillByLabel(tester, 'People').selected, isFalse);
    expect(find.byType(PhotoTile), findsNWidgets(11));
    expect(find.text('11'), findsOneWidget);

    await tester.ensureVisible(find.text('Screenshots'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Screenshots'));
    await tester.pumpAndSettle();

    expect(find.byType(PhotoTile), findsNWidgets(2));
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('text search combines with the active filter', (tester) async {
    await pumpSearch(tester);

    await tester.ensureVisible(find.text('Screenshots'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Screenshots'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'mist');
    await tester.pumpAndSettle();

    expect(find.byType(PhotoTile), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('typing in the search bar filters the grid', (tester) async {
    await pumpSearch(tester);

    await tester.enterText(find.byType(TextField), 'dawn');
    await tester.pumpAndSettle();

    expect(find.byType(PhotoTile), findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();

    expect(find.byType(PhotoTile), findsNothing);
    expect(find.text('No photos match your search'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('search grid stays packed (no holes) while filtering',
      (tester) async {
    await pumpSearch(tester);

    var grid = tester.widget<MosaicGrid>(find.byType(MosaicGrid));
    expect(isPackedLayout(grid.spans, grid.columnCount), isTrue);

    for (final label in ['People', 'Screenshots', 'Documents', 'Notes', 'Videos']) {
      await tester.ensureVisible(find.text(label));
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      grid = tester.widget<MosaicGrid>(find.byType(MosaicGrid));
      expect(isPackedLayout(grid.spans, grid.columnCount), isTrue,
          reason: 'grid has holes after $label filter');
    }
  });

  testWidgets('search grid tiles are squares sized from the parent',
      (tester) async {
    await pumpSearch(tester);

    final grid = tester.widget<MosaicGrid>(find.byType(MosaicGrid));
    final cell =
        (kTestCanvas.width - 2 * AppSpacing.containerMargin) / grid.columnCount;

    final sizes = <Size>{};
    final tiles = find.byType(PhotoTile);
    for (var i = 0; i < tiles.evaluate().length; i++) {
      sizes.add(tester.getSize(tiles.at(i)));
    }

    expect(sizes, {Size(cell, cell)});
  });

  testWidgets('search tab is active in the bottom nav', (tester) async {
    await pumpSearch(tester);

    expect(find.byTooltip('Search'), findsOneWidget);
    expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
  });

  testWidgets('navigates to Profile via the bottom nav', (tester) async {
    await pumpSearch(tester);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
