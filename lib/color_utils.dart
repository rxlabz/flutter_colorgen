import 'package:color/color.dart' as colr;
import 'package:flutter/material.dart';

MaterialColor newColorSwatch(Color color, {bool opaque}) {
  final c = opaque ? color.withOpacity(1.0) : color;
  return MaterialColor(c.value, getMaterialColorValues(c));
}

Map<int, Color> getMaterialColorValues(Color primary) => <int, Color>{
      50: getSwatchShade(primary, 50),
      100: getSwatchShade(primary, 100),
      200: getSwatchShade(primary, 200),
      300: getSwatchShade(primary, 300),
      400: getSwatchShade(primary, 400),
      500: getSwatchShade(primary, 500),
      600: getSwatchShade(primary, 600),
      700: getSwatchShade(primary, 700),
      800: getSwatchShade(primary, 800),
      900: getSwatchShade(primary, 900),
    };

Color getSwatchShade(Color c, int swatchValue) {
  final hsl = colr.RgbColor(c.red, c.green, c.blue).toHslColor();
  final rgbResult =
      colr.HslColor(hsl.h, hsl.s, 100 - swatchValue / 10).toRgbColor();
  return Color.fromRGBO(rgbResult.r, rgbResult.g, rgbResult.b, 1.0);
}

List<Color> getMaterialColorShades(MaterialColor color) => [
      color[50],
      color[100],
      color[200],
      color[300],
      color[400],
      color[500],
      color[600],
      color[700],
      color[800],
      color[900]
    ];

Color getContrastColor(Color c) =>
    c.red + c.green + c.blue < 380 ? Colors.white : Colors.black;
