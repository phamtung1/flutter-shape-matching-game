import 'package:flutter_shapes_matching_game/services/data-change-notifier.dart';
import 'package:flutter_shapes_matching_game/ui/components/shape-list-container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/target-list-container.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Duration _animationDuration = Duration(milliseconds: 500);
  double _top = 0.0;
  bool _isProcessing = false;
  
  @override
  Widget build(BuildContext context) {
    var backgroundImage = Provider.of<DataChangeNotifier>(context).backgroundImage;

    return Scaffold(
      appBar: AppBar(
        title: Text("Shapes Matching Game"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _onNewGame(context);
        },
        label: Text('New Game'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
          child: Stack(
            children: _buidChildren(context),
          ),
        ),
      ),
    );
  }

  void _onNewGame(BuildContext context) {
    if (_isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _top = -TargetListContainer.ContainerHeight;
    });
    
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _top = 0;
      });
      Provider.of<DataChangeNotifier>(context).initializeShapeList();
    
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          _isProcessing = false;
        });
      });
    });
  }

  List<Widget> _buidChildren(BuildContext context) {
    bool isFinished = Provider.of<DataChangeNotifier>(context).isFinished;

    return <Widget>[
      AnimatedPositioned(
        duration: _animationDuration,
        child: TargetListContainer(),
        top: _top,
        left: 0,
        right: 0,
      ),
      Positioned(
        child: isFinished
            ? _createFinishedText(context)
            : Icon(Icons.north, size: 50, color: Colors.black54),
        bottom: 230,
        left: 0,
        right: 0,
      ),
      Positioned(
        child: Center(child: ShapeListContainer()),
        bottom: 100,
        left: 0,
        right: 0,
      ),
    ];
  }

  Widget _createFinishedText(BuildContext context) {
    return Text('Well Done!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: 40,
        ));
  }
}
