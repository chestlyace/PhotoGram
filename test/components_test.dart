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
