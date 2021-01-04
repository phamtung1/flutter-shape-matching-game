import 'package:flutter/material.dart';
import 'package:flutter_shapes_matching_game/ui/home-page.dart';
import 'package:provider/provider.dart';

import 'services/data-change-notifier.dart';

void main() async {
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
            builder: (context) => DataChangeNotifier(), child: HomePage())
      },
      initialRoute: HomePageRoute,
    );
  }
}