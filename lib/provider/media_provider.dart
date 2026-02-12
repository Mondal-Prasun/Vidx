import 'package:flutter/services.dart';

class ImageMedia {
  ImageMedia();

  String name = "";
  double size = 0;
  double height = 0;
  double width = 0;
  Uint8List bytes = Uint8List.fromList([]);

  ImageMedia.fromMap(Map<dynamic, dynamic> data) {
    if (data.isNotEmpty) {
      name = data["mediaTitle"];
      size = double.parse(data["mediaSize"].toString());
      height = double.parse(data["mediaImageHeight"]);
      width = double.parse(data["mediaImageWidth"]);
      bytes = data["mediaByte"] as Uint8List;
    }
  }
}

class VideoMedia {
  VideoMedia();
  String name = "";
  double size = 0;
  double height = 0;
  double width = 0;
  double duration = 0;
  Uint8List bytes = Uint8List.fromList([]);

  VideoMedia.fromMap(Map<dynamic, dynamic> data) {
    if (data.isNotEmpty) {
      name = data["mediaTitle"];
      size = double.parse(data["mediaSize"].toString());
      height = double.parse(data["mediaVideoHeight"]);
      width = double.parse(data["mediaVideoWidth"]);
      bytes = data["mediaByte"] as Uint8List;
      duration = double.parse(data["mediaVideoDuration"]);
    }
  }
}
