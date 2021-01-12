import 'dart:math';

import 'package:flutter_shapes_matching_game/basic_game/model/shape_model.dart';
import 'package:flutter_shapes_matching_game/basic_game/services/data_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class _DragTargetShapeState extends State<DragTargetShape>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(onWillAccept: (ShapeModel data) {
      return data.icon == widget.acceptedIcon;
    }, onAccept: (ShapeModel data) async {
      Provider.of<DataChangeNotifier>(context).dropSuccess(data.index);
      widget.onDragged(data.name);
      if (Provider.of<DataChangeNotifier>(context).isFinished) {
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
    if (droppedShape == null) {
      return Container(
        height: shapeSize,
        width: shapeSize,
        child: ImageIcon(AssetImage(widget.acceptedIcon),
            size: shapeSize, color: Colors.black45),
      );
    } else {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) {
          var newAngle = cos(_animationController.value * 3.14 * 2) / 5;

          return Transform.rotate(
            angle: newAngle,
            child: child,
          );
        },
        child: Container(
          height: shapeSize,
          width: shapeSize,
          child: Image.asset(widget.acceptedIcon),
        ),
      );
    }
  }
}
