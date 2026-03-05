import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as p;

import 'dart:io';

mixin StorageSave {
  Future<String> saveData(String fileName, Uint8List fileBytes) async {
    final appPath = await getApplicationDocumentsDirectory();
    final String storePath = p.join(appPath.path, fileName);

    final f = File(storePath);
    f.writeAsBytesSync(fileBytes);

    return storePath;
  }

  Future<String> getTempPath({required String fileName}) async {
    final appTempPath = await getTemporaryDirectory();

    final String tempStorePath = p.join(appTempPath.path, fileName);

    return tempStorePath;
  }
}
