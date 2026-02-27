import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:uuid/uuid.dart';

Future<String> _saveData(String fileName, Uint8List fileBytes) async {
  final appPath = await getApplicationDocumentsDirectory();
  final String storePath = p.join(appPath.path, fileName);

  final f = File(storePath);
  f.writeAsBytesSync(fileBytes);

  return storePath;
}

class ImageMedia {
  ImageMedia();

  String uuid = "";
  String name = "";
  double size = 0;
  double height = 0;
  double width = 0;
  String filePath = "";

  ImageMedia.fromMap(Map<dynamic, dynamic> data) {
    if (data.isNotEmpty) {
      final bytes = data["mediaByte"] as Uint8List;

      uuid = Uuid().v4().toString();
      name = data["mediaTitle"];
      size = double.parse(data["mediaSize"].toString());
      height = double.parse(data["mediaImageHeight"]);
      width = double.parse(data["mediaImageWidth"]);

      _saveData(name, bytes).then(
        (path) {
          filePath = path;
        },
        onError: (err) {
          print(err);
        },
      );
    }
  }
}

class VideoMedia {
  VideoMedia();

  String uuid = "";
  String name = "";
  double size = 0;
  double height = 0;
  double width = 0;
  double duration = 0;
  String filePath = "";

  VideoMedia.fromMap(Map<dynamic, dynamic> data) {
    if (data.isNotEmpty) {
      uuid = Uuid().v4().toString();
      name = data["mediaTitle"];
      size = double.parse(data["mediaSize"].toString());
      height = double.parse(data["mediaVideoHeight"]);
      width = double.parse(data["mediaVideoWidth"]);
      final bytes = data["mediaByte"] as Uint8List;
      duration = double.parse(data["mediaVideoDuration"]);

      _saveData(name, bytes).then(
        (path) {
          filePath = path;
        },
        onError: (err) {
          print(err);
        },
      );
    }
  }
}
