import 'package:flutter/material.dart';
import 'package:flutter_shapes_matching_game/basic_game/services/data_change_notifier.dart';
import 'package:flutter_shapes_matching_game/basic_game/ui/components/draggable_shape.dart';
import 'package:provider/provider.dart';

class ShapeListContainer extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buildShapes(context),
    );
  }

  List<Widget> buildShapes(BuildContext context) {
    List<Widget> shapes = [];
    var items = Provider.of<DataChangeNotifier>(context).items;
    var totalItems = Provider.of<DataChangeNotifier>(context).totalItems;
    var shapeSize = Provider.of<DataChangeNotifier>(context).shapeSize;

    for (int i = 0; i < totalItems; i++) {
      var item =
          items.firstWhere((element) => element.index == i, orElse: () => null);

      shapes.add(
        SizedBox(
          // SizedBox is a placeholder for our shapes
          width: shapeSize,
          height: shapeSize,
          child: Container(
            child: item == null
                ? null
                : DraggableShape(
                    index: item.index,
                  ),
          ),
        ),
      );
    }

    return shapes;
  }
}
