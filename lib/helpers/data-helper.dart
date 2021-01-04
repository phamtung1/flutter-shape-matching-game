
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shapes_matching_game/model/shape-model.dart';

class DataHelper {
 static final List<IconData> _availableIcons = [
  Icons.stop_circle,
  Icons.favorite,
  Icons.grade,
  Icons.home,
  Icons.cloud
];

static final List<Color> _availableColors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.pink,
  Colors.orange,
];

 static List<ShapeModel> createShapeList(){
   var random = new Random();
   var totalItems = 2 + random.nextInt(3);
   var items = <ShapeModel>[];
   for(var i = 0; i < totalItems; i++)
   {
     items.add(ShapeModel(index: i, color: _availableColors[i], icon: _availableIcons[i]));
   }

   return items;
  }
}