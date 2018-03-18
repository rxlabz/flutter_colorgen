import 'package:color/color.dart' as colr;
import 'package:flutter/material.dart';

enum RGB { R, G, B }
enum HSL { H, S, L }

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
    c.red + c.green + c.blue < 450 ? Colors.white : Colors.black;

colr.HslColor colorToHsl(Color c) =>
    colr.Color.rgb(c.red, c.green, c.blue).toHslColor();

String colorToHex32(Color color) =>
    '#${color.value.toRadixString(16).padLeft(8, '0')}';

List<Color> getHueGradientColors({int steps: 36}) =>
    List.generate(steps, (value) => value).map<Color>((v) {
      final hsl = colr.HslColor(v * (360 / steps), 67, 50);
      final rgb = hsl.toRgbColor();
      return Color.fromRGBO(rgb.r, rgb.g, rgb.b, 1.0);
    }).toList();

int getRGBChannelValue(Color c, RGB channel) {
  switch (channel) {
    case RGB.R:
      return c.red;
    case RGB.G:
      return c.green;
    case RGB.B:
      return c.blue;
  }
  throw Exception('Invalid RGB channel : $channel');
}

Color getRGBChannelColor(Color c, RGB channel) {
  switch (channel) {
    case RGB.R:
      return Color.fromRGBO(getRGBChannelValue(c, RGB.R), 0, 0, 1.0);
    case RGB.G:
      return Color.fromRGBO(0, getRGBChannelValue(c, RGB.G), 0, 1.0);
    case RGB.B:
      return Color.fromRGBO(0, 0, getRGBChannelValue(c, RGB.B), 1.0);
  }

  throw Exception('Invalid RGB channel : $channel');
}

Color getMinSaturation(Color c) {
  final hsl = colorToHsl(c);
  final minS = colr.HslColor(hsl.h, 0, hsl.l);
  final minS_rgb = minS.toRgbColor();
  return Color.fromRGBO(minS_rgb.r, minS_rgb.g, minS_rgb.b, 1.0);
}

Color getMaxSaturation(Color c) => hslToColor(withSaturation(colorToHsl(c), 100));

colr.RgbColor toRgb(Color c) => colr.RgbColor(c.red, c.green, c.blue);

Color rgbToColor(colr.RgbColor c) => Color.fromRGBO(c.r, c.g, c.b, 1.0);

Color hslToColor(colr.HslColor hsl) => rgbToColor(hsl.toRgbColor());

colr.HslColor withSaturation(colr.HslColor hsl, int saturation) =>
    colr.HslColor(hsl.h, saturation, hsl.l);

colr.HslColor withHue(colr.HslColor hsl, num hue) =>
    colr.HslColor(hue, hsl.s, hsl.l);

colr.HslColor withLight(colr.HslColor hsl, num light) =>
    colr.HslColor(hsl.h, hsl.s, light);
