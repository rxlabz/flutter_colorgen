import 'package:flutter/material.dart';
import 'package:flutter_rgb_hsl/color_pickers.dart';
import 'package:flutter_rgb_hsl/color_utils.dart';

void main() => runApp(new ColorApp());

Color kInitialColor = Colors.blueGrey.shade500;

class ColorApp extends StatefulWidget {
  @override
  ColorAppState createState() {
    return new ColorAppState();
  }
}

class ColorAppState extends State<ColorApp> {
  MaterialColor currentColor = newColorSwatch(kInitialColor);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'RGB - HSL',
      theme: new ThemeData(primarySwatch: currentColor),
      home: new MainScreen(
          onNewMaterialColor: (c) => setState(() => currentColor = c)),
    );
  }
}

class MainScreen extends StatefulWidget {
  final ValueChanged<MaterialColor> onNewMaterialColor;
  MainScreen({this.onNewMaterialColor});

  @override
  _MainScreenState createState() => new _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {

  Color color = kInitialColor;

  /*get labelColor =>
      color.red + color.green + color.blue < 380 ? Colors.white : Colors.black;*/

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
                height: 60.0,
                color: color,
                child: Center(
                    child: Text(
                  '#${color.value.toRadixString(16).padLeft(8, '0')}',
                  style: TextStyle(color: getContrastColor(color)),
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
              MaterialColorSwatches(color)
            ],
          ),
        ),
      );

  void onColor(Color newColor) {
    widget.onNewMaterialColor(newColorSwatch(newColor, opaque:true));
    setState(() => color = newColor);
  }
}

class MaterialColorSwatches extends StatefulWidget {
  final Color color;

  MaterialColorSwatches(this.color);

  @override
  _MaterialColorSwatchState createState() => new _MaterialColorSwatchState();
}

class _MaterialColorSwatchState extends State<MaterialColorSwatches> {
  @override
  Widget build(BuildContext context) {
    final c = newColorSwatch(widget.color);
    return new Wrap(
      children: getMaterialColorShades(c).map<Widget>((c) {
        return Container(
          alignment: Alignment.center,
          color: c,
          width: 60.0,
          height: 60.0,
          child: Text(
            '#${c.value.toRadixString(16).padLeft(8,'0').toUpperCase()}',
            style: TextStyle(fontSize: 10.0, color: getContrastColor(c)),
          ),
        );
      }).toList(),
    );
  }
}
