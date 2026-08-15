import '../models/photoAsset.dart';

/// A day's worth of photos, ordered newest first.
class DaySection {
  const DaySection({required this.day, required this.photos});

  final DateTime day;
  final List<PhotoAsset> photos;
}

const _kMonthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Groups [photos] into day sections, newest day first, newest photo first
/// within each day.
List<DaySection> groupPhotosByDay(List<PhotoAsset> photos) {
  final sorted = [...photos]..sort((a, b) => b.created.compareTo(a.created));
  final sections = <DaySection>[];
  DateTime? currentDay;
  var currentPhotos = <PhotoAsset>[];
  for (final photo in sorted) {
    final day =
        DateTime(photo.created.year, photo.created.month, photo.created.day);
    if (currentDay != day) {
      if (currentDay != null) {
        sections.add(DaySection(day: currentDay, photos: currentPhotos));
      }
      currentDay = day;
      currentPhotos = [];
    }
    currentPhotos.add(photo);
  }
  if (currentDay != null) {
    sections.add(DaySection(day: currentDay, photos: currentPhotos));
  }
  return sections;
}

/// Header label for [day]: "Today", "Yesterday", "August 10" for the current
/// year, otherwise "August 10, 2025".
String dayLabel(DateTime day, {DateTime? now}) {
  final reference = now ?? DateTime.now();
  final dayOnly = DateTime(day.year, day.month, day.day);
  final referenceOnly =
      DateTime(reference.year, reference.month, reference.day);
  final diff = referenceOnly.difference(dayOnly).inDays;
  if (diff == 0) {
    return 'Today';
  }
  if (diff == 1) {
    return 'Yesterday';
  }
  final month = _kMonthNames[day.month - 1];
  if (day.year == reference.year) {
    return '$month ${day.day}';
  }
  return '$month ${day.day}, ${day.year}';
}
