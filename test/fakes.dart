import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photogram/models/photoAsset.dart';
import 'package:photogram/services/photoLibraryService.dart';

final Uint8List kTestImageBytes = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

ImageProvider testImage() => MemoryImage(kTestImageBytes);

/// [count] photos all dated today, so the library shows a "Today" section.
List<PhotoAsset> todayPhotos([int count = 2]) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day, 12);
  return [
    for (var i = 0; i < count; i++)
      makePhoto('p$i', today.subtract(Duration(hours: i))),
  ];
}

PhotoAsset makePhoto(String id, DateTime created) => PhotoAsset(
      id: id,
      created: created,
      thumbnail: MemoryImage(kTestImageBytes),
      original: MemoryImage(kTestImageBytes),
    );

class FakePhotoLibraryService implements PhotoLibraryService {
  FakePhotoLibraryService({
    this.granted = true,
    this.photos = const [],
    this.delay = Duration.zero,
  });

  bool granted;
  List<PhotoAsset> photos;
  Duration delay;
  int requestCount = 0;
  bool openSettingsCalled = false;

  @override
  Future<bool> requestAccess() async {
    requestCount++;
    await Future<void>.delayed(delay);
    return granted;
  }

  @override
  Future<List<PhotoAsset>> loadPhotos() async {
    await Future<void>.delayed(delay);
    return photos;
  }

  @override
  Future<void> openSettings() async {
    openSettingsCalled = true;
  }
}
