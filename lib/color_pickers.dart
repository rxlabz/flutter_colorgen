import 'package:color/color.dart' as colr;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  double _a = 0.0;

  set a(double a) {
    _a = a;
    updateColor();
  }

  RGBPickerState(this._color);

  void updateColor() =>
      color = Color.fromRGBO(_r.toInt(), _g.toInt(), _b.toInt(), _a);

  @override
  void initState() {
    super.initState();
  }

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
    _a = _color.opacity;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Red (${_r.round()})',
              style: TextStyle(color: Colors.red.shade600),
            ),
            SizedBox(
                width: 160.0,
                child: Slider(
                  key: new Key('sldR'),
                  label: 'Red',
                  value: _r,
                  max: 255.0,
                  onChanged: (value) => setState(() => r = value),
                )),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Green (${_g.round()})',
                style: TextStyle(color: Colors.green.shade600),
              ),
              SizedBox(
                  width: 160.0,
                  child: Slider(
                    key: new Key('sldG'),
                    label: 'Green',
                    value: _g.roundToDouble(),
                    max: 255.0,
                    onChanged: (value) => setState(() => g = value),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Blue (${_b.round()})',
                style: TextStyle(color: Colors.blue.shade600),
              ),
              SizedBox(
                  width: 160.0,
                  child: Slider(
                    key: new Key('sldB'),
                    label: 'Blue',
                    value: _b.roundToDouble(),
                    max: 255.0,
                    onChanged: (value) => setState(() => b = value),
                  )),
            ],
          ),
          /*
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Opacity (${_a.toStringAsFixed(2)})',
                style: TextStyle(color: Colors.black.withOpacity(_a)),
              ),
              SizedBox(
                  width: 160.0,
                  child: Slider(
                    key: new Key('sldO'),
                    label: 'Opacity',
                    value: _a,
                    max: 1.0,
                    onChanged: (value) => setState(() => a = value),
                  )),
            ],
          ),*/
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

  Color hslToColor(colr.HslColor hsl) {
    colr.RgbColor rgb = _color.toRgbColor();
    return Color.fromRGBO(rgb.r, rgb.g, rgb.b, 1.0);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(HSLPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) {
      _color = new colr.Color.rgb(
              widget.color.red, widget.color.green, widget.color.blue)
          .toHslColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    _h = _color.h.toDouble();
    _s = _color.s.toDouble();
    _l = _color.l.toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Hue (${_h.roundToDouble()})'),
              SizedBox(
                  width: 160.0,
                  child: Slider(
                    key: new Key('sldH'),
                    label: 'Hue',
                    value: _h.roundToDouble(),
                    max: 360.0,
                    onChanged: (value) => setState(() => h = value),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Saturation (${_s.roundToDouble()})'),
              Flexible(
                child: SizedBox(
                    width: 160.0,
                    child: Slider(
                      key: new Key('sldS'),
                      label: 'Saturation',
                      value: _s.roundToDouble(),
                      max: 100.0,
                      onChanged: (value) => setState(() => s = value),
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Light (${_l.roundToDouble()})'),
              SizedBox(
                  width: 160.0,
                  child: Slider(
                    key: new Key('sldL'),
                    label: 'Light',
                    value: _l.roundToDouble(),
                    max: 100.0,
                    onChanged: (value) => setState(() => l = value),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
