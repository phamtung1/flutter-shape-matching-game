import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shapes_matching_game/basic_game/services/data_change_notifier.dart';
import 'package:provider/provider.dart';

import 'basic_game/ui/basic_game_page.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
          await SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp],
          ); // To turn off landscape mode
          SystemChrome.setEnabledSystemUIOverlays([]);
   runApp(MyApp());
}

const String HomePageRoute =  "HomePage";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        HomePageRoute: (BuildContext context) => ChangeNotifierProvider(
            create: (_) => new DataChangeNotifier(),
            child: BasicGamePage())
      },
      initialRoute: HomePageRoute,
    );
  }
}
