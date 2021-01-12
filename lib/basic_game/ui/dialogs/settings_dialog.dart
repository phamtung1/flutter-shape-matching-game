import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shapes_matching_game/basic_game/helpers/data_helper.dart';

class SettingsDialog extends StatefulWidget {
  final List<String> checkedItems;
  SettingsDialog({@required this.checkedItems});

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  List<String> _checkedItems;

  @override
  void initState() {
    super.initState();
    _checkedItems = [...widget.checkedItems];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        height: 450,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Stack(children: [
            Text(
              "Settings",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            contentBox(context),
            Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                child: Icon(Icons.save, color: Colors.white,),
                color: Colors.blue,
                onPressed: () {
                  Navigator.pop(context, _checkedItems);
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  contentBox(context) {
    return ListView(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        children: DataHelper.FOLDERS
            .map(
              (text) => CheckboxListTile(
                secondary: Image.asset('assets/images/$text/0.png'),
                value: _checkedItems.contains(text),
                onChanged: (bool newValue) {
                  setState(() {
                    if (newValue) {
                      if (!_checkedItems.contains(text)) {
                        _checkedItems.add(text);
                      }
                    } else {
                      if (_checkedItems.contains(text)) {
                        _checkedItems.remove(text);
                      }
                    }
                  });
                },
              ),
            )
            .toList());
  }
}
