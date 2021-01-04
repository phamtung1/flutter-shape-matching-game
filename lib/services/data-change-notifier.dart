import 'dart:math';

import 'package:flutter_shapes_matching_game/model/shape-model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shapes_matching_game/helpers/data-helper.dart';
import 'package:flutter/foundation.dart';

class DataChangeNotifier with ChangeNotifier {
  double _shapeSize = 0;
  int _totalItems = 0;
  List<ShapeModel> _items;
  List<ShapeModel> _droppedItems = [];
  List<ShapeModel> _targetItems = [];
  bool _isFinished = false;

  double get shapeSize => _shapeSize;
  int get totalItems => _totalItems;
  List<ShapeModel> get items => _items;
  List<ShapeModel> get droppedItems => _droppedItems;
  List<ShapeModel> get targetItems => _targetItems;
  bool get isFinished => _isFinished;

  DataChangeNotifier(){
    this.initializeShapeList();
  }

  /// Drop a shape successfully by the index
  dropSuccess(int index) {
    var item = _items.firstWhere((element) => element.index == index,
        orElse: () => null);
    if (item != null) {
      _items.removeWhere((element) => element.index == index);
      _droppedItems.add(item);
      _isFinished = _items.isEmpty;
      notifyListeners();
    }
  }

  initializeShapeList() {
    _items = DataHelper.createShapeList();
    
    _droppedItems = [];
    _targetItems = _shuffle(_items);
    _isFinished = false;
    _totalItems = _items.length;
    _shapeSize = 120.0 - (_totalItems * 10);
    notifyListeners();
  }

  
  List _shuffle(List<ShapeModel> items) {
    List<ShapeModel> newList = [...items];
    var random = new Random();

    // Go through all elements.
    for (var i = newList.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = newList[i];
      newList[i] = newList[n];
      newList[n] = temp;
    }

    return newList;
  }
}
