import 'dart:math';

import 'package:color/color.dart' as colr;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorgen/color_utils.dart';
import 'package:flutter_colorgen/widgets/color_slider.dart';

typedef void ColorCallback(Color color);

typedef Widget ColorSliderBuilder({
  @required Color startColor,
  @required Color endColor,
  @required Color thumbColor,
  @required Key sliderKey,
  @required ValueChanged<double> onChange,
  List<Color> colors,
  double value,
  double minValue,
  maxValue,
});

Widget buildSlider<RGB>(
        {@required Color startColor,
        @required Color endColor,
        @required Color thumbColor,
        @required RGB channel,
        Key sliderKey,
        List<Color> colors,
        double value,
        minValue: 0.0,
        maxValue: 1.0,
        ValueChanged<double> onChange}) =>
    GradientSlider(
      key: sliderKey,
      label: value.toInt().toString(),
      value: min(max(minValue, value), maxValue),
      startColor: startColor,
      endColor: endColor,
      colors: colors,
      thumbColor: thumbColor,
      min: minValue,
      max: maxValue,
      onChanged: (newValue) => onChange(newValue),
    );

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

  double test;

  void updateColor() => setState(
      () => color = Color.fromRGBO(_r.toInt(), _g.toInt(), _b.toInt(), 1.0));

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
          RGBSliderRow(
              sliderKey: Key('sldR'),
              sliderBuilder: buildSlider,
              startColor: Colors.black,
              endColor: Color.fromRGBO(255, 0, 0, 1.0),
              thumbColor: getRGBChannelColor(_color, RGB.R),
              value: _r,
              label: 'Red',
              labelStyle: TextStyle(color: Colors.red.shade600),
              maxValue: 255.0,
              onChange: (value) => setState(() => r = value)),
          RGBSliderRow(
              sliderKey: Key('sldG'),
              sliderBuilder: buildSlider,
              startColor: Colors.black,
              endColor: Color.fromRGBO(0, 255, 0, 1.0),
              thumbColor: getRGBChannelColor(_color, RGB.G),
              value: _g,
              label: 'Green',
              labelStyle: TextStyle(color: Colors.green.shade600),
              maxValue: 255.0,
              onChange: (value) => setState(() => g = value)),
          RGBSliderRow(
              sliderKey: Key('sldB'),
              sliderBuilder: buildSlider,
              value: _b,
              label: 'Blue',
              startColor: Colors.black,
              endColor: Color.fromRGBO(0, 0, 255, 1.0),
              thumbColor: getRGBChannelColor(_color, RGB.B),
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
    widget.onColor(hslToColor(_color));
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
          HSLSliderRow(
            sliderKey: Key('sldH2'),
            sliderBuilder: buildSlider,
            value: _h,
            label: 'Hue',
            maxValue: 359.0,
            onChange: (value) => setState(() => h = value),
            colors: getHueGradientColors(),
            thumbColor: hslToColor(_color),
          ),
          HSLSliderRow(
            sliderKey: Key('sldS'),
            sliderBuilder: buildSlider,
            value: _s,
            label: 'Saturation',
            maxValue: 100.0,
            onChange: (value) => setState(() => s = value),
            startColor: getMinSaturation(widget.color),
            endColor: getMaxSaturation(widget.color),
            thumbColor: hslToColor(_color),
          ),
          HSLSliderRow(
            sliderKey: Key('sldL'),
            sliderBuilder: buildSlider,
            value: _l,
            label: 'Light',
            maxValue: 100.0,
            onChange: (value) => setState(() => l = value),
            endColor: Colors.white,
            startColor: Colors.black,
            colors: [Colors.black,hslToColor(_color), Colors.white],
            thumbColor: hslToColor(_color),
          ),
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

class HSLSliderRow extends GradientSliderRow {
  HSLSliderRow(
      {Key sliderKey,
      @required double value,
      @required ValueChanged<double> onChange,
      @required ColorSliderBuilder sliderBuilder,
      @required Color thumbColor,
      Color startColor,
      Color endColor,
      List<Color> colors,
      String label,
      TextStyle labelStyle,
      double minValue: 0.0,
      double maxValue: 1.0,
      double width: 160.0,
      Key key})
      : super(
          key: key,
          value: value,
          sliderKey: sliderKey,
          onChange: onChange,
          sliderBuilder: sliderBuilder,
          startColor: startColor,
          endColor: endColor,
          colors: colors,
          thumbColor: thumbColor,
          label: label,
          labelStyle: labelStyle,
          minValue: minValue,
          maxValue: maxValue,
          width: width,
        );

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        '$label : ${value.round()}',
        style: labelStyle ?? Theme.of(context).textTheme.body1,
        overflow: TextOverflow.ellipsis,
      ),
      sliderBuilder(
          startColor: startColor,
          endColor: endColor,
          colors: colors,
          thumbColor: thumbColor,
          sliderKey: sliderKey,
          maxValue: maxValue,
          onChange: onChange,
          value: min(max(minValue, value), maxValue)),
    ]);
  }
}

class RGBSliderRow extends GradientSliderRow<RGB> {

  RGBSliderRow(
      {Key sliderKey,
      @required double value,
      @required ValueChanged<double> onChange,
      @required ColorSliderBuilder sliderBuilder,
      @required Color startColor,
      @required Color endColor,
      @required Color thumbColor,
      String label,
      TextStyle labelStyle,
      double minValue: 0.0,
      double maxValue: 1.0,
      double width: 160.0,
      Key key})
      : super(
          key: key,
          value: value,
          sliderKey: sliderKey,
          onChange: onChange,
          sliderBuilder: sliderBuilder,
          startColor: startColor,
          endColor: endColor,
          thumbColor: thumbColor,
          label: label,
          labelStyle: labelStyle,
          minValue: minValue,
          maxValue: maxValue,
          width: width,
        );

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text(
        '$label : ${value.round()}',
        style: labelStyle ?? Theme.of(context).textTheme.body1,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(
          width: width,
          child: sliderBuilder(
              startColor: startColor,
              endColor: endColor,
              thumbColor: thumbColor,
              sliderKey: sliderKey,
              maxValue: maxValue,
              onChange: onChange,
              value: min(max(minValue, value), maxValue))),
    ]);
  }
}

abstract class GradientSliderRow<T> extends StatelessWidget {
  GradientSliderRow(
      {this.sliderKey,
      @required this.value,
      @required this.onChange,
      @required this.sliderBuilder,
      @required this.startColor,
      @required this.endColor,
      @required this.thumbColor,
      this.colors,
      this.label,
      this.labelStyle,
      this.minValue: 0.0,
      this.maxValue: 1.0,
      this.width: 160.0,
      Key key})
      : super(key: key);

  final double value;

  final ValueChanged<double> onChange;
  final String label;

  final TextStyle labelStyle;

  final double width;
  final double minValue;

  final double maxValue;
  final Color startColor;
  final Color endColor;
  final List<Color> colors;

  final Color thumbColor;

  final Key sliderKey;

  final ColorSliderBuilder sliderBuilder;
}
