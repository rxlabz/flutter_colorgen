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
          /*title: Text('#${color.value.toRadixString(16).padLeft(8, '0')}'),*/
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Swatches',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: getContrastColor(backgroundColor)),
                ),
              ),
              MaterialColorSwatches(color)
            ],
          ),
        ),
      );

  void onColor(Color newColor) {
    widget.onNewMaterialColor(newColorSwatch(newColor, opaque: true));
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

    return LayoutBuilder(
      builder: (context, constraints) {
        print('_MaterialColorSwatchState.build... $constraints');
        return Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: getMaterialColorShades(c).map<Widget>((c) {
            return Container(
              alignment: Alignment.center,
              color: c,
              width: constraints.maxWidth / 2.1,
              height: 60.0,
              child: Text(
                '#${c.value.toRadixString(16).padLeft(8,'0').toUpperCase()}',
                style: TextStyle(fontSize: 14.0, color: getContrastColor(c)),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
