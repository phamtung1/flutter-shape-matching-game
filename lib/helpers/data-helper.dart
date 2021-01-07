import 'dart:math';

import 'package:flutter_shapes_matching_game/model/game-model.dart';
import 'package:flutter_shapes_matching_game/model/shape-model.dart';

const int MaxNumberOfImages = 10;

class DataHelper {
  static const FOLDERS = <String>['1-animals','2-cakes', '3-fruits','4-insects'];

  static GameModel createShapeList() {
    var random = new Random();
    var totalItems = 2 + random.nextInt(3);
    
    var imageSetIndex = random.nextInt(FOLDERS.length);
    var folder = FOLDERS[imageSetIndex];
    var backgroundImage = 'assets/images/bg${imageSetIndex + 1}.jpg';

    // generate a random unique numbers
    var list = new List<int>.generate(MaxNumberOfImages, (int index) => index + 1);
    list.shuffle();

    var shapeList = <ShapeModel>[];
    for (var i = 0; i < totalItems; i++) {
      shapeList.add(ShapeModel(index: i, icon: 'assets/images/$folder/${list[i]}.png'));
    }

    return GameModel(backgroundImage: backgroundImage, shapeList: shapeList);
  }
}
