import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_shapes_matching_game/services/data-change-notifier.dart';
import 'package:flutter_shapes_matching_game/ui/components/shape-list-container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/target-list-container.dart';

class HomePage extends StatefulWidget {
  static final _audioPlayer = AssetsAudioPlayer.newPlayer();

  HomePage() {
    _openAndPlay();
  }

  _togglePlay(bool isPlaying) async {
    await (isPlaying ? _audioPlayer.play() : _audioPlayer.stop());
  }

  _openAndPlay() async {
    if (_audioPlayer.isPlaying.value) {
      return;
    }

    _audioPlayer.open(Audio("assets/audios/IntroTheme.mp3"),
        autoStart: true,
        showNotification: false,
        volume: 0.2,
        loopMode: LoopMode.single);
  }

  _playClickSound() async { 
    AssetsAudioPlayer.playAndForget(Audio("assets/audios/click.mp3"));
  }

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 300);

  String _imageCaption = '';
  bool _isMusicEnabled = true;
  double _top = 0.0;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    var backgroundImage =
        Provider.of<DataChangeNotifier>(context).backgroundImage;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget._playClickSound();
          _onNewGame(context);
        },
        label: Text('New Game'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(backgroundImage), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
      _imageCaption = '';
      _top = -TargetListContainer.containerHeight;
    });

    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _top = 0;
      });
      Provider.of<DataChangeNotifier>(context).initializeShapeList();

      Future.delayed(Duration(milliseconds: 800), () {
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
        child: TargetListContainer(
          onDragged: (String itemName){
            setState(() {
              _imageCaption = itemName;
            });
          },
        ),
        top: _top,
        left: 0,
        right: 0,
      ),
      // Image caption
      if(_imageCaption.isNotEmpty)
       Positioned(
        child: Center(
          child: Text(
            _imageCaption,
            style: TextStyle(fontSize: 36.0, color: Colors.blue[700]),
            )
          ),
        top: TargetListContainer.containerHeight + 30,
        left: 0,
        right: 0,
      ),
      
      // Arrow & Finish text
      Align(
        alignment: Alignment.center,
        child: isFinished
            ? _createFinishedText(context)
            : Icon(Icons.north, size: 50, color: Colors.black54),
      ),
      // Shape list
      Positioned(
        child: Center(child: ShapeListContainer()),
        bottom: 130,
        left: 0,
        right: 0,
      ),
      
      // Music button
      Align(
        alignment: Alignment.bottomLeft,
        child: IconButton(
          iconSize: 30.0,
          icon: Icon(_isMusicEnabled ? Icons.volume_up : Icons.volume_off),
          color: Colors.blue[600],
          onPressed: () {
            setState(() {
              _isMusicEnabled = !_isMusicEnabled;
            });

            widget._togglePlay(_isMusicEnabled);
          },
        ),
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
