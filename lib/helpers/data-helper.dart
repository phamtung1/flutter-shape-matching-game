import 'dart:math';

import 'package:flutter_shapes_matching_game/model/game-model.dart';
import 'package:flutter_shapes_matching_game/model/shape-model.dart';

const int MaxNumberOfImages = 10;

class DataHelper {
  static const FOLDERS = <String>['1-animals','2-cakes', '3-fruits','4-insects'];
  static const ItemNames = {
    0: ['pig', 'dog', 'rhino', 'elephant', 'giraffe', 'monkey', 'zebra', 'lion', 'crocodile', 'chicken'],
    1: ['cake','cake','cake','cake','cake','cake','cake','cake','cake','cake'],
    2: ['mango', 'watermelon', 'kiwi', 'pineapple', 'strawberry', 'apple', 'grapes', 'avocado', 'cherry', 'lettuce'],
    3: ['fly', 'worm', 'bee', 'ladybug', 'snail', 'dragonfly', 'grasshopper', 'butterfly', 'spider', 'cockroach'],
  };
  

  static GameModel createShapeList() {
    var random = new Random();
    var totalItems = 2 + random.nextInt(3);
    
    var imageSetIndex = random.nextInt(FOLDERS.length);
    var folder = FOLDERS[imageSetIndex];
    var backgroundImage = 'assets/images/bg${imageSetIndex + 1}.jpg';

    // generate a random unique numbers
    var list = new List<int>.generate(MaxNumberOfImages, (int index) => index);
    list.shuffle();
    var nameSet = ItemNames[imageSetIndex];
    var shapeList = <ShapeModel>[];
    for (var i = 0; i < totalItems; i++) {
      var imageIndex = list[i];
      shapeList.add(ShapeModel(index: i, icon: 'assets/images/$folder/$imageIndex.png', name: nameSet[imageIndex]));
    }

    return GameModel(backgroundImage: backgroundImage, shapeList: shapeList);
  }
}
