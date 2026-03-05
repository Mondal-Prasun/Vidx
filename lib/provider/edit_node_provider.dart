import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:vidx/provider/ffmpeg_provider.dart';
import 'package:vidx/provider/media_provider.dart';
import 'package:vidx/provider/storage_save.dart';

class EditNode with StorageSave, FfmpegWrap {
  String spritePath = "";
  double startDuration = 0;
  double endDuration = 0;
  int spriteXindexNum = 0;
  Duration mediaDuration = Duration();
}

class VideoNode extends EditNode {
  VideoNode._();
  late final VideoMedia videoMedia;

  static Future<VideoNode> create(VideoMedia vMedia) async {
    final instance = VideoNode._();

    instance.videoMedia = vMedia;
    final spriteUuid = Uuid().v4();

    final spritePath = await instance.getTempPath(fileName: "$spriteUuid.jpg");

    instance.spriteXindexNum = await instance.getFramePerSecondSptite(
      filePath: instance.videoMedia.filePath,
      spritePath: spritePath,
      duration: instance.videoMedia.duration,
    );

    instance.spritePath = spritePath;

    instance.mediaDuration = Duration(
      milliseconds: instance.videoMedia.duration.round(),
    );

    return instance;
  }
}

class ImageNode extends EditNode {
  late final ImageMedia imageMedia;
}

class _EditNodeNotifier extends Notifier<EditNode> {
  @override
  EditNode build() => EditNode();

  set currentNode(EditNode editNode) {
    state = editNode;
  }
}

final editNodeProvider = NotifierProvider<_EditNodeNotifier, EditNode>(
  _EditNodeNotifier.new,
);
