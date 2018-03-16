import 'dart:math';

import 'package:color/color.dart' as colr;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rgb_hsl/color_utils.dart';

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
              key: Key('sldR'),
              value: _r,
              label: 'Red',
              labelStyle: TextStyle(color: Colors.red.shade600),
              maxValue: 255.0,
              onChange: (value) => setState(() => r = value)),
          ColorSlider(
              key: Key('sldG'),
              value: _g,
              label: 'Green',
              labelStyle: TextStyle(color: Colors.green.shade600),
              maxValue: 255.0,
              onChange: (value) => setState(() => g = value)),
          ColorSlider(
              key: Key('sldB'),
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
          ColorSlider(
              key: Key('sldH'),
              value: _h,
              label: 'Hue',
              maxValue: 360.0,
              onChange: (value) => setState(() => h = value)),
          ColorSlider(
              key: Key('sldS'),
              value: _s,
              label: 'Saturation',
              maxValue: 100.0,
              onChange: (value) => setState(() => s = value)),
          ColorSlider(
              key: Key('sldL'),
              value: _l,
              label: 'Light',
              maxValue: 100.0,
              onChange: (value) => setState(() => l = value)),
        ],
      ),
    );
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

  ColorSlider(
      {Key key,
      @required this.value,
      @required this.onChange,
      this.label,
      this.labelStyle,
      this.minValue: 0.0,
      this.maxValue: 1.0,
      this.width: 160.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        '$label : ${value.round()}',
        style: labelStyle ?? Theme.of(context).textTheme.body1
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(
          width: width,
          child: Slider(
            key: key,
            label: label,
            value: min(max(minValue, value), maxValue),
            min: minValue,
            max: maxValue,
            onChanged: (newValue) => onChange(newValue),
          )),
    ]);
  }
}
