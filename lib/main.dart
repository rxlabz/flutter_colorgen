import 'package:flutter/material.dart';
import 'package:flutter_colorgen/color_service.dart';
import 'package:flutter_colorgen/color_utils.dart';
import 'package:flutter_colorgen/main_screen.dart';
import 'package:quiver/iterables.dart';

void main() {
  final colorService = ColorService();
  runApp(new ColorApp(colorService));
}

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

  MainScreen({ColorService colorService, Function onNewMaterialColor}) {}
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
                children: enumerate(snapshot.data)
                    .map((c) => Dismissible(
                          child: ListTile(
                            leading: Container(
                              color: c.value,
                              width: 32.0,
                              height: 32.0,
                            ),
                            title: Text(colorToHex32(c.value)),
                            onTap: () {
                              service.select(c.value);
                            },
                          ),
                          key: Key('kColor${c.index}'),
                          onDismissed: (direction) => onRemoveColor,
                        ))
                    .toList(),
              )),
            )
          : Text(snapshot.hasError ? 'Error ${snapshot.error}' : 'Loading...'),
    );
  }

  void onRemoveColor(DismissDirection direction) {}
}
