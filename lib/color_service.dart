import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';

const kFilename = 'colors.json';

class ColorService {
  List<Color> colors = [];

  File colorFile;

  Color selectedColor;

  StreamController<Color> _colorStreamer = new StreamController<Color>();

  Stream<Color> get selectedColor$ => _colorStreamer.stream;

  StreamController<bool> _savingStreamer = new StreamController<bool>();

  Stream<bool> get saving$ => _savingStreamer.stream;

  Future init() async {
    final dirPath = (await getApplicationDocumentsDirectory()).path;
    colorFile = new File('${dirPath}/$kFilename');
    if (!await colorFile.exists()) colorFile.create();
    colorFile.writeAsString('[0]');
  }

  Future<List<Color>> load() async {
    if( colorFile == null){
      final dirPath = (await getApplicationDocumentsDirectory()).path;
      colorFile = new File('${dirPath}/$kFilename');
      if (!(await colorFile.exists())) colorFile.create();
      final colorData = json.decode(await colorFile.readAsString());
      colors = (colorData as List).map((value) => Color(value)).toList();
    }
    return colors;
  }

  void save(Color c) async {
    colors.add(c);
    _savingStreamer.add(await _export(colors));
  }

  Future<bool> _export(List<Color> colors) async {
    final res = await colorFile
        .writeAsString(json.encode(colors.map((c) => c.value).toList()));
    return res != null;
  }

  select(Color c) {
    _colorStreamer.add(c);
  }
}
