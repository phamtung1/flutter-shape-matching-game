import 'dart:math';

import 'package:flutter_shapes_matching_game/basic_game/model/game_model.dart';
import 'package:flutter_shapes_matching_game/basic_game/model/shape_model.dart';

const int MaxNumberOfImages = 10;

class DataHelper {
  static const FOLDERS = <String>[
    '1-animals',
    '2-dinos',
    '3-fruits',
    '4-insects',
    '5-sea'
  ];
  static const ItemNames = {
    0: [
      'pig',
      'dog',
      'rhino',
      'elephant',
      'giraffe',
      'monkey',
      'zebra',
      'lion',
      'crocodile',
      'chicken'
    ],
    1: [
      'parasaurolophus',
      'allosaurus',
      'ankylosaurus',
      'pteranodon',
      'brachiosaurus',
      'kentrosaurus',
      'stegosaurus',
      'styracosaurus',
      'triceratops',
      'tyrannosaurus'
    ],
    2: [
      'mango',
      'watermelon',
      'kiwi',
      'pineapple',
      'strawberry',
      'apple',
      'grapes',
      'avocado',
      'cherry',
      'lettuce'
    ],
    3: [
      'fly',
      'worm',
      'bee',
      'ladybug',
      'snail',
      'dragonfly',
      'grasshopper',
      'butterfly',
      'spider',
      'cockroach'
    ],
    4: [
      'starfish',
      'crab',
      'octopus',
      'dolphin',
      'sea turtle',
      'whale',
      'seahorse',
      'shrimp',
      'shell',
      'squid'
    ],
  };

  static GameModel createShapeList(List<String> enabledSets) {
    var random = new Random();

    var totalItems = 2 + random.nextInt(2); // 2 -> 4
    var imageSetIndex = 0;
    var folder = '';
    while (true) {
      imageSetIndex = random.nextInt(FOLDERS.length);
      folder = FOLDERS[imageSetIndex];
      if (enabledSets.length == 0 || enabledSets.contains(folder)) {
        break;
      }
    }

    var backgroundImage = 'assets/images/bg${imageSetIndex + 1}.jpg';

    // generate a random unique numbers
    var list = new List<int>.generate(MaxNumberOfImages, (int index) => index);
    list.shuffle();
    var nameSet = ItemNames[imageSetIndex];
    var shapeList = <ShapeModel>[];
    for (var i = 0; i < totalItems; i++) {
      var imageIndex = list[i];
      shapeList.add(ShapeModel(
          index: i,
          icon: 'assets/images/$folder/$imageIndex.png',
          name: nameSet[imageIndex]));
    }

    return GameModel(backgroundImage: backgroundImage, shapeList: shapeList);
  }
}
