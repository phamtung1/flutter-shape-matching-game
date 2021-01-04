import 'package:flutter_shapes_matching_game/services/data-change-notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DraggableShape extends StatelessWidget {
  DraggableShape({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {

    var data = Provider.of<DataChangeNotifier>(context).items.firstWhere((element) => element.index == index, orElse: () => null);
  var shapeSize = Provider.of<DataChangeNotifier>(context).shapeSize;

    return Draggable(
      data: data,
      childWhenDragging: Container(
        height: shapeSize,
        width: shapeSize,
        child: Icon(data.icon, size: shapeSize, color: Colors.grey)
      ),
      // dragging item
      feedback: Container(
        height: shapeSize,
        width: shapeSize,
        child: Icon(data.icon, size: shapeSize, color: data.color)
      ),
      child: Container(
        height: shapeSize,
        width: shapeSize,
        child: Icon(data.icon, size: shapeSize, color: data.color)
      ),
    );
  }
}
