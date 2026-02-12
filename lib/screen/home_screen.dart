import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vidx/channel/android_channel.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final AndoidChannel _andoidChannel = AndoidChannel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final image = await _andoidChannel.getSelectedImage();

              showDialog(
                context: context,
                builder: (ctx) {
                  return Image.memory(image.bytes);
                },
              );
            },
            child: Text("Image"),
          ),
          ElevatedButton(
            onPressed: () async {
              final video = await _andoidChannel.getSelectVideo();

              final tempPath = await getTemporaryDirectory();
              final filePath = p.join(tempPath.path, video.name);
              final vFile = File(filePath);
              vFile.writeAsBytesSync(video.bytes);

              showDialog(
                context: context,
                builder: (ctx) {
                  return TestVideo(videoFile: vFile);
                },
              );
            },
            child: Text("Video"),
          ),
        ],
      ),
    );
  }
}

class TestVideo extends StatefulWidget {
  const TestVideo({super.key, required this.videoFile});
  final File videoFile;

  @override
  State<StatefulWidget> createState() => _TestVideoState();
}

class _TestVideoState extends State<TestVideo> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(widget.videoFile);

    _videoPlayerController.initialize().then((value) {
      setState(() {
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);
        _videoPlayerController.setVolume(1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _videoPlayerController.value.aspectRatio,
      child: VideoPlayer(_videoPlayerController),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }
}
