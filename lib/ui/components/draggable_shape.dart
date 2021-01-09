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

class _DraggableShape extends State<DraggableShape> {
  FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;

  @override
  initState() {
    super.initState();
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
