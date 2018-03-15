import 'package:flutter/material.dart';
import 'package:flutter_rgb_hsl/color_pickers.dart';

void main() => runApp(new ColorApp());

class ColorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'RGB - HSL',
      theme: new ThemeData(primarySwatch: Colors.blueGrey),
      home: new MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => new _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color color = Colors.red.shade500;

  get labelColor =>
      color.red + color.green + color.blue < 380 ? Colors.white : Colors.black;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('#${color.value.toRadixString(16).padLeft(8, '0')}'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 300.0,
                height: 120.0,
                color: color,
                child: Center(
                    child: Text(
                  '#${color.value.toRadixString(16).padLeft(8, '0')}',
                  style: TextStyle(color: labelColor),
                )),
              ),
              RGBPicker(
                onColor: onColor,
                color: color,
              ),
              HSLPicker(
                onColor: onColor,
                color: color,
              ),
            ],
          ),
        ),
      );

  void onColor(Color newColor) => setState(() => color = newColor);
}
