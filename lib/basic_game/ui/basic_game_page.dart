import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shapes_matching_game/basic_game/services/data_change_notifier.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import 'components/shape_list_container.dart';
import 'components/target_list_container.dart';
import 'dialogs/settings_dialog.dart';

class BasicGamePage extends StatefulWidget {
  static final _audioPlayer = AssetsAudioPlayer.newPlayer();

  BasicGamePage() {
    _openAndPlay();
  }

  _togglePlay(bool isPlaying) async {
    await (isPlaying ? _audioPlayer.play() : _audioPlayer.stop());
  }

  _openAndPlay() async {
    if (_audioPlayer.isPlaying.value) {
      return;
    }

    _audioPlayer.open(Audio("assets/audios/background.mp3"),
        autoStart: true,
        showNotification: false,
        volume: 0.2,
        loopMode: LoopMode.single);
  }

  _playClickSound() async {
    AssetsAudioPlayer.playAndForget(Audio("assets/audios/click.mp3"));
  }

  _playCheerSound() async {
    AssetsAudioPlayer.playAndForget(Audio("assets/audios/cheer.mp3"));
  }

  _BasicGamePageState createState() => _BasicGamePageState();
}

class _BasicGamePageState extends State<BasicGamePage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();

  static const Duration _animationDuration = Duration(milliseconds: 300);

  String _imageCaption = '';
  bool _isMusicEnabled = true;
  double _top = 0.0;
  bool _isProcessing = false;
  bool _isFinished = false;

  @override
  Widget build(BuildContext context) {
    var backgroundImage =
        Provider.of<DataChangeNotifier>(context).backgroundImage;

    return Scaffold(
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

  Future<void> _speak(String text) async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text);
  }

  void _onNewGame(BuildContext context) {
    widget._playClickSound();

    if (_isProcessing) {
      return;
    }

    _isFinished = false;

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
    return <Widget>[
      AnimatedPositioned(
        duration: _animationDuration,
        child: TargetListContainer(
          onDragged: (String itemName) {
            this._speak(itemName);
            setState(() {
              _imageCaption = itemName;
            });
          },
          onFinished: () {
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                _isFinished = true;
              });

              widget._playCheerSound();
            });
          },
        ),
        top: _top,
        left: 0,
        right: 0,
      ),
      // Image caption
      if (_imageCaption.isNotEmpty)
        Positioned(
          child: Center(child: _buildCaptionText()),
          top: TargetListContainer.containerHeight + 10,
          left: 0,
          right: 0,
        ),

      // Arrow & Finish text
      Align(
        alignment: Alignment.center,
        child: _isFinished
            ? _createFinishedScreen(context)
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
      Align(alignment: Alignment.bottomLeft, child: _buildMusicButton()),
      Align(
          alignment: Alignment.bottomRight,
          child: _buildSettingsButton(context)),
    ];
  }

  Widget _createFinishedScreen(BuildContext context) {
    return InkWell(
      onTap: () {
        _onNewGame(context);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 180, 0, 0),
        child: Image.asset(
          "assets/images/goodjob.gif",
        ),
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return IconButton(
      iconSize: 30.0,
      icon: Icon(Icons.settings),
      color: Colors.blue[600],
      onPressed: () async {
        var enabledSets = Provider.of<DataChangeNotifier>(context).enabledSets;
        List<String> checkedItems = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return SettingsDialog(
              checkedItems: enabledSets,
              );
            }
        );

        if (checkedItems != null && checkedItems.isNotEmpty) {
          Provider.of<DataChangeNotifier>(context)
              .setEnabledImageSet(checkedItems);
          _onNewGame(context);
        }
      },
    );
  }

  Widget _buildMusicButton() {
    return IconButton(
      iconSize: 30.0,
      icon: Icon(_isMusicEnabled ? Icons.volume_up : Icons.volume_off),
      color: Colors.blue[600],
      onPressed: () {
        setState(() {
          _isMusicEnabled = !_isMusicEnabled;
        });

        widget._togglePlay(_isMusicEnabled);
      },
    );
  }

  Text _buildCaptionText() {
    return Text(
      _imageCaption,
      style: TextStyle(
        fontSize: 36,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black87,
            blurRadius: 10.0,
            offset: Offset(3.0, 3.0),
          ),
          Shadow(
            color: Colors.black87,
            blurRadius: 10.0,
            offset: Offset(-3.0, 3.0),
          ),
        ],
      ),
    );
  }
}
