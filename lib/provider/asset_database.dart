import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:vidx/provider/media_provider.dart';

enum _Mediatable { Video, Image }

class AssetDatabase {
  late Database _db;
  final String _dbName = "vidx_media";
  final String _videoTable = '''CREATE TABLE Video (
    uuid TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    size REAL NOT NULL,
    height REAL NOT NULL,
    width REAL NOT NULL,
    duration REAL NOT NULL,
    path TEXT NOT NULL
);''';

  final String _imageTable = '''CREATE TABLE Image (
    uuid TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    size REAL NOT NULL,
    height REAL NOT NULL,
    width REAL NOT NULL,
    path TEXT NOT NULL
);''';

  AssetDatabase._();

  Future<void> _inilizeDb() async {
    final String dbPath = await getDatabasesPath();
    final String absolutePath = p.join(dbPath, _dbName);

    _db = await openDatabase(
      absolutePath,
      version: 1,
      onCreate: (db, version) {
        db.execute(_videoTable);
        db.execute(_imageTable);
      },
    );
  }

  static Future<AssetDatabase> init() async {
    final instance = AssetDatabase._();
    await instance._inilizeDb();
    return instance;
  }

  Future<void> insertVideoData(VideoMedia vMedia) async {
    await _db.insert(_Mediatable.Video.name, {
      "uuid": vMedia.uuid,
      "name": vMedia.name,
      "size": vMedia.size,
      "height": vMedia.height,
      "width": vMedia.width,
      "duration": vMedia.duration,
      "path": vMedia.filePath,
    });
  }

  Future<List<VideoMedia>> getAllVideoes() async {
    final res = await _db.query(_Mediatable.Video.name);

    List<VideoMedia> videoList = [];

    for (final e in res) {
      videoList.add(VideoMedia.fromDbMap(e));
    }

    return videoList;
  }

  Future<void> insertImageData(ImageMedia iMedia) async {
    await _db.insert(_Mediatable.Image.name, {
      "uuid": iMedia.uuid,
      "name": iMedia.name,
      "size": iMedia.size,
      "height": iMedia.height,
      "width": iMedia.width,
      "path": iMedia.filePath,
    });
  }

  Future<List<ImageMedia>> getAllImages() async {
    final res = await _db.query(_Mediatable.Image.name);

    List<ImageMedia> imageList = [];

    for (final e in res) {
      imageList.add(ImageMedia.fromDbMap(e));
    }

    return imageList;
  }
}
