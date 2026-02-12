import 'package:flutter/services.dart';
import 'package:vidx/provider/media_provider.dart';

class AndoidChannel {
  final MethodChannel _methodChannel = MethodChannel("VIDX_CHANNEL");

  Future<ImageMedia> getSelectedImage() async {
    final res = await _methodChannel.invokeMethod("selectImage");
    return ImageMedia.fromMap(res);
  }

  Future<VideoMedia> getSelectVideo() async {
    final res = await _methodChannel.invokeMethod("selectVideo");
    return VideoMedia.fromMap(res);
  }
}
