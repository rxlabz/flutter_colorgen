import 'package:flutter/material.dart';
import 'package:flutter_colorgen/color_utils.dart';
import 'package:flutter_colorgen/widgets/color_pickers.dart';
import 'package:flutter_colorgen/widgets/swatches.dart';

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
      title: 'ColorGen',
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

  Color get backgroundColor => getSwatchShade(color, 700);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('Colorgen'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildPrimarySwatch(color),
              RGBPicker(onColor: onColor, color: color),
              HSLPicker(onColor: onColor, color: color),
              ColorSwatchesWidget(color)
            ],
          ),
        ),
      );

  Widget _buildPrimarySwatch(Color color) => Container(
      height: 60.0,
      color: color,
      child: Center(
          child: Text(colorToHex32(color),
              style: TextStyle(color: getContrastColor(color)))));

  void onColor(Color newColor) {
    widget.onNewMaterialColor(newColorSwatch(newColor, opaque: true));
    setState(() => color = newColor);
  }
}
