import 'package:flutter/material.dart';
import 'package:flutter_colorgen/color_utils.dart';

const _kGridSpacing = 6.0;

class ColorSwatchesWidget extends StatefulWidget {
  final Color color;

  ColorSwatchesWidget(this.color);

  @override
  _MaterialColorSwatchState createState() => new _MaterialColorSwatchState();
}

class _MaterialColorSwatchState extends State<ColorSwatchesWidget> {
  @override
  Widget build(BuildContext context) {
    final c = newColorSwatch(widget.color);

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - _kGridSpacing) / 2;
        return Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Swatches',
                style: Theme.of(context).textTheme.subhead.copyWith(
                  color: getContrastColor(getSwatchShade(widget.color, 700))),
              ),
            ),
            Wrap(
              spacing: _kGridSpacing,
              runSpacing: _kGridSpacing,
              children: getMaterialColorShades(c).map<Widget>((c) {
                return Container(
                  alignment: Alignment.center,
                  color: c,
                  width: itemWidth,
                  height: 60.0,
                  child: Text(colorToHex32(c),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: getContrastColor(c),
                    )),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
