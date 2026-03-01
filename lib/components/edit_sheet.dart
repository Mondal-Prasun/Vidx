import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidx/provider/media_node_provider.dart';
import 'package:vidx/screen/choose_media.dart';

class EditSheet extends ConsumerStatefulWidget {
  const EditSheet({super.key, required this.cHeight, required this.cWidth});
  final double cHeight;
  final double cWidth;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditSheetState();
}

class _EditSheetState extends ConsumerState<EditSheet> {
  void _chooseVideo() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChooseMedia(nodeName: NodeConstant.video),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.cWidth,
      height: widget.cHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: Colors.grey.shade200,
      ),

      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: widget.cWidth,
              height: widget.cHeight / 3.5,
              child: Row(
                spacing: 10,
                children: [
                  IconButton(
                    icon: Icon(Icons.video_file_outlined),
                    onPressed: _chooseVideo,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
