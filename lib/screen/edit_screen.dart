import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidx/components/edit_sheet.dart';

class EditScreen extends ConsumerStatefulWidget {
  const EditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _editSheetAnimationController;
  late Animation<double> _editSheetAnimation;

  bool _isVisible = false;

  void _openEditSheet() async {
    setState(() {
      if (!_isVisible) {
        _editSheetAnimationController.forward();
        _isVisible = !_isVisible;
      } else {
        _editSheetAnimationController.reverse();
        _isVisible = !_isVisible;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _editSheetAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _editSheetAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.easeInSine))
        .animate(_editSheetAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final double editSheetHeight = size.height / 2;
    final double editSheetWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _openEditSheet,
            icon: Icon(Icons.brush_outlined),
            style: IconButton.styleFrom(
              foregroundColor: _isVisible ? Colors.white : null,
              backgroundColor: _isVisible ? Colors.purple : null,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _editSheetAnimation,
            builder: (_, _) {
              return Positioned(
                bottom: (-editSheetHeight * _editSheetAnimation.value),
                child: EditSheet(
                  cHeight: editSheetHeight,
                  cWidth: editSheetWidth,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
