import 'package:flutter_shapes_matching_game/model/shape-model.dart';
import 'package:flutter_shapes_matching_game/services/data-change-notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DragTargetShape extends StatefulWidget {
  DragTargetShape({
    Key key,
    @required this.acceptedIcon,
  }) : super(key: key);

  final IconData acceptedIcon;

  _DragTargetShapeState createState() => _DragTargetShapeState();
}

class _DragTargetShapeState extends State<DragTargetShape> {

  @override
  Widget build(BuildContext context) {
    return DragTarget(onWillAccept: (ShapeModel data) {
      return data.icon == widget.acceptedIcon;
    }, onAccept: (ShapeModel data) {
      Provider.of<DataChangeNotifier>(context).dropSuccess(data.index);
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
      child: Icon(widget.acceptedIcon,
          size: shapeSize, color: droppedShape?.color ?? Colors.black54),
    );
  }
}
