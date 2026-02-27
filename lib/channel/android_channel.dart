import 'package:flutter/services.dart';
import 'package:vidx/provider/asset_database.dart';
import 'package:vidx/provider/media_provider.dart';

class AndoidChannel {
  final MethodChannel _methodChannel = MethodChannel("VIDX_CHANNEL");
  final AssetDatabase _assetDb = AssetDatabase.init();

  Future<ImageMedia> getSelectedImage() async {
    final res = await _methodChannel.invokeMethod("selectImage");

    final imageMedia = ImageMedia.fromMap(res);
    await _assetDb.insertImageData(imageMedia);

    return imageMedia;
  }

  Future<VideoMedia> getSelectVideo() async {
    final res = await _methodChannel.invokeMethod("selectVideo");

    final videoMedia = VideoMedia.fromMap(res);
    await _assetDb.insertVideoData(videoMedia);

    return videoMedia;
  }
}
