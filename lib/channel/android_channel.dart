import 'package:flutter/services.dart';
import 'package:vidx/provider/media_provider.dart';
import 'package:vidx/main.dart';

class AndoidChannel {
  final MethodChannel _methodChannel = MethodChannel("VIDX_CHANNEL");

  Future<ImageMedia> getSelectedImage() async {
    final res = await _methodChannel.invokeMethod("selectImage");

    final imageMedia = await ImageMedia.fromMap(res);
    await assetDb.insertImageData(imageMedia);

    return imageMedia;
  }

  Future<VideoMedia> getSelectVideo() async {
    final res = await _methodChannel.invokeMethod("selectVideo");

    final videoMedia = await VideoMedia.fromMap(res);
    await assetDb.insertVideoData(videoMedia);

    return videoMedia;
  }
}
