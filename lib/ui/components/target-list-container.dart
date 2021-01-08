import 'package:flutter/material.dart';
import 'package:flutter_shapes_matching_game/services/data-change-notifier.dart';
import 'package:provider/provider.dart';
import 'drag-target-shape.dart';

class TargetListContainer extends StatelessWidget {
  static final double containerHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight,
      decoration: new BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        boxShadow: [
          new BoxShadow(
            color: Colors.blueAccent.withOpacity(0.4),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildTargets(context),
      ),
      
    );
  }

  List<Widget> buildTargets(BuildContext context) {
    List<Widget> targets = [];
    var items = Provider.of<DataChangeNotifier>(context).targetItems;

    for (int i = 0; i < items.length; i++) {
      targets.add(DragTargetShape(acceptedIcon: items[i].icon));
    }

    return targets;
  }
}
