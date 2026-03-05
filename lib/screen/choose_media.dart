import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:vidx/provider/edit_node_provider.dart';
import 'package:vidx/provider/media_node_provider.dart';
import 'package:vidx/channel/android_channel.dart';
import 'dart:io';

import 'package:vidx/provider/media_provider.dart';
import 'package:vidx/main.dart';

class ChooseMedia extends ConsumerStatefulWidget {
  const ChooseMedia({super.key, required this.nodeName});
  final NodeConstant nodeName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChooseMediaState();
}

class _ChooseMediaState extends ConsumerState<ChooseMedia> {
  final AndoidChannel _andoidChannel = AndoidChannel();

  void _chooseMediaFromStorage() async {
    switch (widget.nodeName) {
      case .video:
        await _andoidChannel.getSelectVideo();
        setState(() {});
        break;
      case .image:
        await _andoidChannel.getSelectedImage();
        setState(() {});
        break;
      case .audio:
        AssertionError("Audio choosing is not implemanted yet");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final double cWidth = size.width / 3;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose ${widget.nodeName.name}",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("cancel", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("save", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _chooseMediaFromStorage,
        child: Icon(Icons.add_outlined),
      ),
      body: FutureBuilder(
        future: widget.nodeName == NodeConstant.video
            ? assetDb.getAllVideoes()
            : assetDb.getAllImages(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return Center(child: Text("Choose from device"));
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: data.length,
              itemBuilder: (_, index) {
                if (widget.nodeName == NodeConstant.video) {
                  return _SmallVideoView(
                    cWidth: cWidth,
                    videoMedia: data[index] as VideoMedia,
                  );
                } else if (widget.nodeName == NodeConstant.image) {
                  return _SmallImageView(
                    cWidth: cWidth,
                    imageMedia: data[index] as ImageMedia,
                  );
                }
                return null;
              },
            );
          }

          return Center(child: Text("Choose from device"));
        },
      ),
    );
  }
}

class _SmallVideoView extends ConsumerStatefulWidget {
  const _SmallVideoView({required this.cWidth, required this.videoMedia});
  final double cWidth;
  final VideoMedia videoMedia;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SmallVideoViewState();
}

class _SmallVideoViewState extends ConsumerState<_SmallVideoView> {
  late final VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.file(File(widget.videoMedia.filePath))
          ..initialize().then((value) {
            setState(() {});
          });
  }

  @override
  void dispose() {
    super.dispose();
    () async {
      await _videoPlayerController.dispose();
    }();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final vNode = await VideoNode.create(widget.videoMedia);

        ref.read(editNodeProvider.notifier).currentNode = vNode;
      },
      onLongPress: () {
        _videoPlayerController.play();
      },
      child: Container(
        width: widget.cWidth,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: VideoPlayer(_videoPlayerController),
      ),
    );
  }
}

class _SmallImageView extends StatefulWidget {
  const _SmallImageView({required this.cWidth, required this.imageMedia});
  final double cWidth;
  final ImageMedia imageMedia;

  @override
  State<StatefulWidget> createState() => _SmallImageViewState();
}

class _SmallImageViewState extends State<_SmallImageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.cWidth,
      height: widget.cWidth,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.file(File(widget.imageMedia.filePath)),
      ),
    );
  }
}
