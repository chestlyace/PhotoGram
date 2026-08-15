import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../models/photoAsset.dart';

/// Reads photos from the device library. The only layer that talks to
/// photo_manager, so the UI stays testable.
class PhotoLibraryService {
  Future<bool> requestAccess() async {
    final state = await PhotoManager.requestPermissionExtend();
    return state.hasAccess;
  }

  Future<List<PhotoAsset>> loadPhotos() async {
    final paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );
    if (paths.isEmpty) {
      return const [];
    }
    final all = paths.first;
    final count = await all.assetCountAsync;
    if (count == 0) {
      return const [];
    }
    final entities = await all.getAssetListPaged(page: 0, size: count);
    final photos = entities
        .map(
          (entity) => PhotoAsset(
            id: entity.id,
            created: entity.createDateTime,
            thumbnail: AssetEntityImageProvider(
              entity,
              isOriginal: false,
              thumbnailSize: const ThumbnailSize(512, 512),
            ),
            original: AssetEntityImageProvider(entity),
          ),
        )
        .toList()
      ..sort((a, b) => b.created.compareTo(a.created));
    return photos;
  }

  Future<void> openSettings() => PhotoManager.openSetting();
}
