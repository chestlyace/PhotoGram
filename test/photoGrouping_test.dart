import 'package:flutter_test/flutter_test.dart';
import 'package:photogram/utils/photoGrouping.dart';

import 'fakes.dart';

void main() {
  group('groupPhotosByDay', () {
    test('sorts newest first and groups by day', () {
      final sections = groupPhotosByDay([
        makePhoto('a', DateTime(2026, 8, 10, 9)),
        makePhoto('b', DateTime(2026, 8, 15, 18)),
        makePhoto('c', DateTime(2026, 8, 14, 11)),
        makePhoto('d', DateTime(2026, 8, 15, 7)),
      ]);

      expect(sections.length, 3);
      expect(sections[0].day, DateTime(2026, 8, 15));
      expect([for (final p in sections[0].photos) p.id], ['b', 'd']);
      expect(sections[1].day, DateTime(2026, 8, 14));
      expect(sections[2].day, DateTime(2026, 8, 10));
    });

    test('returns empty for no photos', () {
      expect(groupPhotosByDay([]), isEmpty);
    });

    test('does not mutate the input list', () {
      final input = [makePhoto('a', DateTime(2026, 8, 10))];
      groupPhotosByDay(input);
      expect(input.single.id, 'a');
    });
  });

  group('dayLabel', () {
    final now = DateTime(2026, 8, 15, 12);

    test('is Today for the same day', () {
      expect(dayLabel(DateTime(2026, 8, 15), now: now), 'Today');
    });

    test('is Yesterday for the previous day', () {
      expect(dayLabel(DateTime(2026, 8, 14), now: now), 'Yesterday');
    });

    test('uses month and day for the current year', () {
      expect(dayLabel(DateTime(2026, 8, 10), now: now), 'August 10');
    });

    test('includes the year for other years', () {
      expect(dayLabel(DateTime(2025, 8, 10), now: now), 'August 10, 2025');
    });
  });
}
