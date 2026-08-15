import 'package:flutter/widgets.dart';

/// A single photo from the device library, decoupled from the plugin.
class PhotoAsset {
  const PhotoAsset({
    required this.id,
    required this.created,
    required this.thumbnail,
    required this.original,
  });

  final String id;
  final DateTime created;
  final ImageProvider thumbnail;
  final ImageProvider original;
}
