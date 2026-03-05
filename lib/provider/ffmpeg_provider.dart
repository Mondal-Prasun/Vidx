import 'dart:math';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

mixin FfmpegWrap {
  int spriteElementScale = 160;

  Future<int> getFramePerSecondSptite({
    required String filePath,
    required String spritePath,
    required double duration,
  }) async {
    final sq = sqrt(duration / 1000.0);

    int tileNum = 0;

    if ((sq - sq.truncate()) != 0) {
      tileNum = sq.truncate() + 1;
    } else {
      tileNum = sq.round();
    }

    final fSession = await FFmpegKit.execute(
      "-i $filePath -vf \"fps=1,scale=$spriteElementScale:-1,tile=${tileNum}x$tileNum\" -q:v 5 $spritePath",
    );

    final returnCode = await fSession.getReturnCode();

    if (!ReturnCode.isSuccess(returnCode)) {
      throw ("something went wrong in getFrameSecondSprite");
    }

    return tileNum;
  }
}
