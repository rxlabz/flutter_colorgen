import 'dart:math';

import 'package:color/color.dart' as colr;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorgen/color_utils.dart';
import 'package:flutter_colorgen/widgets/color_slider.dart';

typedef void ColorCallback(Color color);

class RGBPicker extends StatefulWidget {
  final ColorCallback onColor;
  final Color color;
  RGBPicker({@required this.color, this.onColor});

  @override
  RGBPickerState createState() => new RGBPickerState(color);
}

class RGBPickerState extends State<RGBPicker> {
  Color _color;

  set color(Color color) {
    _color = color;
    widget.onColor(_color);
  }

  double _r = 0.0;

  set r(double r) {
    _r = r;
    updateColor();
  }

  double _g = 0.0;

  set g(double g) {
    _g = g;
    updateColor();
  }

  double _b = 0.0;

  set b(double b) {
    _b = b;
    updateColor();
  }

  RGBPickerState(this._color);

  void updateColor() =>
      color = Color.fromRGBO(_r.toInt(), _g.toInt(), _b.toInt(), 1.0);

  @override
  void didUpdateWidget(RGBPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) {
      _color = widget.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    _r = _color.red.toDouble();
    _g = _color.green.toDouble();
    _b = _color.blue.toDouble();

    final hsl = colr.RgbColor(_r, _g, _b).toHslColor();
    final shade50 = colr.HslColor(hsl.h, hsl.s, 95).toRgbColor();

    return Container(
      color: Color.fromRGBO(shade50.r, shade50.g, shade50.b, 1.0),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ColorSlider(
              sliderKey: Key('sldR'),
              value: _r,
              label: 'Red',
              labelStyle: TextStyle(color: Colors.red.shade600),
              maxValue: 255.0,
              onChange: (value) => setState(() => r = value)),
          ColorSlider(
              sliderKey: Key('sldG'),
              value: _g,
              label: 'Green',
              labelStyle: TextStyle(color: Colors.green.shade600),
              maxValue: 255.0,
              onChange: (value) => setState(() => g = value)),
          ColorSlider(
              sliderKey: Key('sldB'),
              value: _b,
              label: 'Blue',
              labelStyle: TextStyle(color: Colors.blue.shade600),
              maxValue: 255.0,
              onChange: (value) => setState(() => b = value)),
        ],
      ),
    );
  }
}

class HSLPicker extends StatefulWidget {
  final ColorCallback onColor;
  final Color color;
  HSLPicker({@required this.color, this.onColor});

  @override
  HSLPickerState createState() => new HSLPickerState(color);
}

class HSLPickerState extends State<HSLPicker> {
  colr.HslColor _color;

  set color(colr.HslColor color) {
    _color = color;
    colr.RgbColor rgb = _color.toRgbColor();
    widget.onColor(Color.fromRGBO(rgb.r, rgb.g, rgb.b, 1.0));
  }

  double _h = 0.0;

  set h(double r) {
    _h = r;
    updateColor();
  }

  double _s = 0.0;

  set s(double g) {
    _s = g;
    updateColor();
  }

  double _l = 0.0;

  set l(double b) {
    _l = b;
    updateColor();
  }

  HSLPickerState(Color c) {
    this._color = colr.RgbColor(c.red, c.green, c.blue).toHslColor();
  }

  void updateColor() => color = new colr.HslColor(_h, _s, _l);

  @override
  void didUpdateWidget(HSLPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) _color = colorToHsl(widget.color);
  }

  @override
  Widget build(BuildContext context) {
    _h = _color.h.toDouble();
    _s = _color.s.toDouble();
    _l = _color.l.toDouble();

    final rgb = colr.HslColor(_h, _s, 95).toRgbColor();

    return Container(
      color: Color.fromRGBO(rgb.r, rgb.g, rgb.b, 1.0),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /*LayoutBuilder(
            builder: (context, constraints) => CustomPaint(
                  size: Size(constraints.maxWidth, 30.0),
                  painter: HueGradientPainter(
                      value: _color.h,
                      onHueSelection: (double hue) => setState(() => h = hue)),
                ),
          ),*/
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Hue : ${_h.round()}',
              style: Theme.of(context).textTheme.body1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
                width: 160.0,
                child: Theme(
                  data: new ThemeData.light().copyWith(
                      sliderTheme: Theme.of(context).sliderTheme.copyWith(
                          thumbShape: RoundColorSliderThumbShape(),
                          valueIndicatorShape:
                              PaddleSliderColorValueIndicatorShape(),
                          activeRailColor: Colors.grey[200])),
                  child: ColorGradientSlider(
                    key: Key('sldH'),
                    label: _h.toInt().toString(),
                    value: min(max(0.0, _h), 360.0),
                    divisions: 360.0.toInt(),
                    min: 0.0,
                    max: 360.0,
                    onChanged: (value) => setState(() => h = value),
                  ),
                )),
          ])
/*          ColorSlider(
              sliderKey: Key('sldH'),
              value: _h,
              label: 'Hue',
              maxValue: 360.0,
              onChange: (value) => setState(() => h = value))*/
              ,
          ColorSlider(
              sliderKey: Key('sldS'),
              value: _s,
              label: 'Saturation',
              maxValue: 100.0,
              onChange: (value) => setState(() => s = value)),
          ColorSlider(
              sliderKey: Key('sldL'),
              value: _l,
              label: 'Light',
              maxValue: 100.0,
              onChange: (value) => setState(() => l = value)),
        ],
      ),
    );
  }
}

class HueGradientPainter extends CustomPainter {
  final ValueChanged<double> onHueSelection;

  final double value;

  HueGradientPainter({this.value, this.onHueSelection});

  Size size;

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    final Gradient gradient = new LinearGradient(
      colors: getHueGradientColors(),
    );
    Rect gradientRect =
        Rect.fromPoints(Offset.zero, Offset(size.width, size.height));
    final gradientPaint = Paint()..shader = gradient.createShader(gradientRect);

    final valueX = value / 360 * size.width;
    Rect cursorRect =
        Rect.fromPoints(Offset(valueX, 0.0), Offset(valueX + 2, size.height));

    canvas.drawRect(gradientRect, gradientPaint);
    final cursorPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(cursorRect, cursorPaint);
  }

  @override
  bool shouldRepaint(HueGradientPainter oldDelegate) =>
      oldDelegate.value != value;

  @override
  bool hitTest(Offset position) {
    final hueValue = position.dx / size.width * 360;
    onHueSelection(hueValue);
    return true;
  }
}

class ColorSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChange;

  final String label;
  final TextStyle labelStyle;

  final double width;

  final double minValue;
  final double maxValue;

  final Key sliderKey;

  ColorSlider(
      {this.sliderKey,
      @required this.value,
      @required this.onChange,
      this.label,
      this.labelStyle,
      this.minValue: 0.0,
      this.maxValue: 1.0,
      this.width: 160.0,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        '$label : ${value.round()}',
        style: labelStyle ?? Theme.of(context).textTheme.body1,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(
          width: width,
          child: Slider(
            key: sliderKey,
            label: value.toInt().toString(),
            value: min(max(minValue, value), maxValue),
            divisions: maxValue.toInt(),
            min: minValue,
            max: maxValue,
            onChanged: (newValue) => onChange(newValue),
          )),
    ]);
  }
}
