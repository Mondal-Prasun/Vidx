import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:uuid/uuid.dart';

class ImageMedia {
  ImageMedia._();
  String uuid = "";
  String name = "";
  double size = 0;
  double height = 0;
  double width = 0;
  String filePath = "";

  Future<String> _saveData(String fileName, Uint8List fileBytes) async {
    final appPath = await getApplicationDocumentsDirectory();
    final String storePath = p.join(appPath.path, fileName);

    final f = File(storePath);
    f.writeAsBytesSync(fileBytes);

    return storePath;
  }

  static Future<ImageMedia> fromMap(Map<dynamic, dynamic> data) async {
    final instance = ImageMedia._();
    if (data.isNotEmpty) {
      final bytes = data["mediaByte"] as Uint8List;

      instance.uuid = Uuid().v4().toString();
      instance.name = data["mediaTitle"];
      instance.size = double.parse(data["mediaSize"].toString());
      instance.height = double.parse(data["mediaImageHeight"]);
      instance.width = double.parse(data["mediaImageWidth"]);

      instance.filePath = await instance._saveData(instance.name, bytes);
    }
    return instance;
  }

  ImageMedia.fromDbMap(Map<String, Object?> data) {
    uuid = data["uuid"].toString();
    name = data["name"].toString();
    size = data["size"] as double;
    height = data["size"] as double;
    width = data["width"] as double;
    filePath = data["path"].toString();
  }
}

class VideoMedia {
  VideoMedia._();
  String uuid = "";
  String name = "";
  double size = 0;
  double height = 0;
  double width = 0;
  double duration = 0;
  String filePath = "";

  Future<String> _saveData(String fileName, Uint8List fileBytes) async {
    final appPath = await getApplicationDocumentsDirectory();
    final String storePath = p.join(appPath.path, fileName);

    final f = File(storePath);
    f.writeAsBytesSync(fileBytes);

    print(
      "this is .................................................$storePath",
    );
    return storePath;
  }

  static Future<VideoMedia> fromMap(Map<dynamic, dynamic> data) async {
    final instance = VideoMedia._();

    if (data.isNotEmpty) {
      instance.uuid = Uuid().v4().toString();
      instance.name = data["mediaTitle"];
      instance.size = double.parse(data["mediaSize"].toString());
      instance.height = double.parse(data["mediaVideoHeight"]);
      instance.width = double.parse(data["mediaVideoWidth"]);
      final bytes = data["mediaByte"] as Uint8List;
      instance.duration = double.parse(data["mediaVideoDuration"]);

      instance.filePath = await instance._saveData(instance.name, bytes);
    }

    return instance;
  }

  VideoMedia.fromDbMap(Map<String, Object?> data) {
    uuid = data["uuid"].toString();
    name = data["name"].toString();
    size = data["size"] as double;
    height = data["size"] as double;
    width = data["width"] as double;
    duration = data["duration"] as double;
    filePath = data["path"].toString();
  }
}
