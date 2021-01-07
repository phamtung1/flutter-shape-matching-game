import 'dart:math';

import 'package:flutter_shapes_matching_game/model/shape-model.dart';

const int MaxNumberOfImages = 10;

class DataHelper {
//  static final List<String> _availableIcons = [
//     "assets/images/fruits/1.png",
//     "assets/images/fruits/2.png",
//     "assets/images/fruits/3.png",
//     "assets/images/fruits/4.png",
//     "assets/images/fruits/5.png",
//     "assets/images/fruits/6.png",
//     "assets/images/cakes/1.png",
//     "assets/images/cakes/2.png",
//     "assets/images/cakes/3.png",
//     "assets/images/cakes/4.png",
//     "assets/images/cakes/5.png",
//     "assets/images/cakes/6.png",
// ];
  
  static List<ShapeModel> createShapeList() {
    var random = new Random();
    var totalItems = 2 + random.nextInt(3);
    var items = <ShapeModel>[];
    var folder = random.nextBool() ? "fruits" : "cakes";
    // generate a random unique numbers
    var list = new List<int>.generate(MaxNumberOfImages, (int index) => index + 1);
    list.shuffle();

    for (var i = 0; i < totalItems; i++) {
      items.add(ShapeModel(index: i, icon: 'assets/images/$folder/${list[i]}.png'));
    }

    return items;
  }
}
