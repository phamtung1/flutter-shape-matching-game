import 'package:flutter_shapes_matching_game/model/shape_model.dart';
import 'package:flutter_shapes_matching_game/services/data_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

enum TtsState { playing, stopped, paused, continued }

class DragTargetShape extends StatefulWidget {
  DragTargetShape({
    Key key,
    @required this.acceptedIcon,
    @required this.onDragged,
    @required this.onFinished,
  }) : super(key: key);

  final String acceptedIcon;
  final Function(String) onDragged;
  final VoidCallback onFinished;

  _DragTargetShapeState createState() => _DragTargetShapeState();
}

class _DragTargetShapeState extends State<DragTargetShape> {
  final FlutterTts flutterTts = FlutterTts();
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
    return DragTarget(onWillAccept: (ShapeModel data) {
      return data.icon == widget.acceptedIcon;
    }, onAccept: (ShapeModel data) async {
      Provider.of<DataChangeNotifier>(context).dropSuccess(data.index);
      widget.onDragged(data.name);
      await this._speak(data.name);
      if(Provider.of<DataChangeNotifier>(context).isFinished)
      {
        widget.onFinished(); 
      }
    }, builder: (context, List<ShapeModel> cd, rd) {
      var droppedShape = Provider.of<DataChangeNotifier>(context)
          .droppedItems
          .firstWhere((element) => element.icon == widget.acceptedIcon,
              orElse: () => null);

      return buildShape(droppedShape);
    });
  }

  Widget buildShape(ShapeModel droppedShape) {
    var shapeSize = Provider.of<DataChangeNotifier>(context).shapeSize;
    return Container(
      height: shapeSize,
      width: shapeSize,
      child: droppedShape == null ? ImageIcon(AssetImage(widget.acceptedIcon), size: shapeSize, color: Colors.black45) :
       Image.asset(widget.acceptedIcon),
    );
  }

  Future<void> _speak(String text) async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text);
  }
}
