import 'package:flutter/material.dart';
import 'package:flutter_colorgen/color_service.dart';
import 'package:flutter_colorgen/color_utils.dart';
import 'package:flutter_colorgen/widgets/color_pickers.dart';
import 'package:flutter_colorgen/widgets/swatches.dart';

void main() {
  final colorService = ColorService();
  runApp(new ColorApp(colorService));
}

Color kInitialColor = Colors.blueGrey.shade500;

class ColorApp extends StatefulWidget {
  ColorService colorService;

  ColorApp(this.colorService);

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
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primarySwatch: currentColor),
      routes: {
        '/': (context) => MainScreen(
            colorService: widget.colorService,
            onNewMaterialColor: (c) => setState(() => currentColor = c)),
        '/saved': (context) => ColorLibrary(widget.colorService)
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  ColorService colorService;

  MainScreen({this.colorService, this.onNewMaterialColor});

  final ValueChanged<MaterialColor> onNewMaterialColor;

  @override
  _MainScreenState createState() => new _MainScreenState();
}

const kSaveSuccessMessage = 'Color saved';

const kSaveErrorMessage = 'Error : can\'t save';

class _MainScreenState extends State<MainScreen> {
  Color color = kInitialColor;

  GlobalKey<ScaffoldState> scaffoldKey;

  Color get backgroundColor => getSwatchShade(color, 700);

  @override
  void initState() {
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    widget.colorService.selectedColor$.listen((c) {
      onColor(c);
      Navigator.of(context).pop();
    });
    widget.colorService.saving$.listen((res) {
      final snack = SnackBar(
        content: Text(res ? kSaveSuccessMessage : kSaveErrorMessage),
        backgroundColor: (res ? Colors.green : Colors.red).shade700,
      );
      scaffoldKey.currentState.showSnackBar(snack);
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: widget.colorService.load(),
        builder: (context, snapshot) => snapshot.hasData
            ? Scaffold(
                key: scaffoldKey,
                backgroundColor: backgroundColor,
                appBar: AppBar(
                  title: Text('Colorgen'),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.save),
                      onPressed: saveColor,
                    ),
                    IconButton(
                      icon: Icon(Icons.folder_special),
                      onPressed: showSavedColors,
                    )
                  ],
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
              )
            : Material(child: Center(child: Text('Loading ${snapshot.error}'))),
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

  void saveColor() {
    widget.colorService.save(color);
  }

  void showSavedColors() {
    print('_MainScreenState.showSavedColors... ');
    Navigator.of(context).pushNamed('/saved');
  }
}

class ColorLibrary extends StatelessWidget {
  final ColorService service;

  ColorLibrary(this.service);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Color>>(
      future: service.load(),
      builder: (context, snapshot) => snapshot.hasData
          ? Scaffold(
              appBar: AppBar(
                title: Text('Colorgen'),
                actions: <Widget>[],
              ),
              body: SingleChildScrollView(
                  child: ListBody(
                children: snapshot.data
                    .map((c) => ListTile(
                          leading: Container(
                            color: c,
                            width: 32.0,
                            height: 32.0,
                          ),
                          title: Text(colorToHex32(c)),
                          onTap: () {
                            service.select(c);
                          },
                        ))
                    .toList(),
              )),
            )
          : Text(snapshot.hasError ? 'Error ${snapshot.error}' : 'Loading...'),
    );
  }
}
