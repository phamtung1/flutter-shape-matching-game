import 'package:flutter_shapes_matching_game/basic_game/helpers/data_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_shapes_matching_game/basic_game/model/shape_model.dart';

class DataChangeNotifier with ChangeNotifier {
  String _backgroundImage = '';
  double _shapeSize = 0;
  int _totalItems = 0;
  List<ShapeModel> _items;
  List<ShapeModel> _droppedItems = [];
  List<ShapeModel> _targetItems = [];
  bool _isFinished = false;
  List<String> _enabledSets = [...DataHelper.FOLDERS];

  String get backgroundImage => _backgroundImage;
  double get shapeSize => _shapeSize;
  int get totalItems => _totalItems;
  List<ShapeModel> get items => _items;
  List<ShapeModel> get droppedItems => _droppedItems;
  List<ShapeModel> get targetItems => _targetItems;
  bool get isFinished => _isFinished;
  List<String> get enabledSets => _enabledSets;

  DataChangeNotifier() {
    this.initializeShapeList();
  }

  setEnabledImageSet(List<String> imageSets) {
    _enabledSets = imageSets;
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
    var gameModel = DataHelper.createShapeList(_enabledSets);
    _backgroundImage = gameModel.backgroundImage;
    _items = gameModel.shapeList;

    _droppedItems = [];
    _targetItems = [...items];
    _targetItems.shuffle();
    _isFinished = false;
    _totalItems = _items.length;
    _shapeSize = 170.0 - (_totalItems * 20);
    notifyListeners();
  }
}
