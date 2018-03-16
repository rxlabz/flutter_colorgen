import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rgb_hsl/color_pickers.dart';
import 'package:flutter_rgb_hsl/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ColorApp show color', (WidgetTester tester) async {

    await tester.pumpWidget(ColorApp());

    expect(find.text('#fff44336'), findsNWidgets(2));
  });

  testWidgets('HSLPicker max / min light show white / black', (WidgetTester tester) async {

    Color currentColor = Colors.red.shade500;

    await tester.pumpWidget(new Directionality(
        textDirection: TextDirection.ltr,
        child: StatefulBuilder(
          builder: (context, setState) => Material(
                child: MediaQuery(
                  data: MediaQueryData.fromWindow(window),
                  child: Center(
                    child: HSLPicker(
                      color: currentColor,
                      onColor: (c) => setState(() => currentColor = c),
                    ),
                  ),
                ),
              ),
        )));

    expect(find.text('Hue (4.0)'), findsOneWidget);
    expect(find.text('Saturation (90.0)'), findsOneWidget);
    expect(find.text('Light (58.0)'), findsOneWidget);

    final tl = tester.getTopLeft(find.byKey(Key('sldL')));
    final br = tester.getBottomRight(find.byKey(Key('sldL')));
    final maxLight = tl + (br - tl)* .99 ;

    await tester.tapAt(maxLight);
    expect(currentColor, equals(Colors.white));

    await tester.pump();

    final minLight = tl + (br - tl)* .01 ;
    await tester.tapAt( minLight );
    expect(currentColor, equals(Colors.black));
  });
}
