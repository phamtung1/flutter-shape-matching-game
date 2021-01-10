import 'dart:math';

import 'package:flutter_shapes_matching_game/model/shape_model.dart';
import 'package:flutter_shapes_matching_game/services/data_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class DraggableShape extends StatefulWidget {
  final int index;
  DraggableShape({
    Key key,
    @required this.index,
  }) : super(key: key);

  @override
  _DraggableShape createState() => _DraggableShape();
}

class _DraggableShape extends State<DraggableShape>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;
  AnimationController _animationController;

  @override
  initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataChangeNotifier>(context).items.firstWhere(
        (element) => element.index == widget.index,
        orElse: () => null);
    var shapeSize = Provider.of<DataChangeNotifier>(context).shapeSize;

    return Draggable(
        data: data,
        childWhenDragging: Container(
            height: shapeSize,
            width: shapeSize,
            child: ImageIcon(
              AssetImage(data.icon),
              size: shapeSize,
              color: Colors.grey[600],
            )),
        // dragging item
        feedback: Container(
          height: shapeSize,
          width: shapeSize,
          child: Image.asset(data.icon),
        ),
        child: _buildChild(data, shapeSize));
  }

  Widget _buildChild(ShapeModel data, double shapeSize) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        var newAngle = cos(_animationController.value * 3.14 * 2) / 10;

        return Transform.rotate(
          angle: newAngle,
          child: child,
        );
      },
      child: Container(
        height: shapeSize,
        width: shapeSize,
        child: InkWell(
          onTap: () {
            this._speak(data.name);
          },
          child: Image.asset(data.icon),
        ),
      ),
    );
  }

  void _speak(String text) async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text);
  }
}
