import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorgen/color_service.dart';
import 'package:flutter_colorgen/main.dart';
import 'package:flutter_colorgen/widgets/color_pickers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ColorApp show color', (WidgetTester tester) async {
    await tester.pumpWidget(ColorApp(ColorService()));

    expect(find.text('#ff607d8b'), findsOneWidget);

    expect(find.text('Hue : 200'), findsOneWidget);
    expect(find.text('Saturation : 18'), findsOneWidget);
    expect(find.text('Light : 46'), findsOneWidget);

    final tl = tester.getTopLeft(find.byKey(Key('sldL')));
    final br = tester.getBottomRight(find.byKey(Key('sldL')));
    final maxLight = tl + (br - tl) * .99;

    await tester.tapAt(maxLight);
    await tester.pump();
    expect(find.text('#ffffffff'), findsOneWidget);

    final minLight = tl + (br - tl) * .01;
    await tester.tapAt(minLight);
    await tester.pump();
    expect(find.text('#ff000000'), findsOneWidget);
  });

  testWidgets('HSLPicker max / min light show white / black',
      (WidgetTester tester) async {
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

    expect(find.text('Hue : 4'), findsOneWidget);
    expect(find.text('Saturation : 90'), findsOneWidget);
    expect(find.text('Light : 58'), findsOneWidget);

    final tl = tester.getTopLeft(find.byKey(Key('sldL')));
    final br = tester.getBottomRight(find.byKey(Key('sldL')));
    final maxLight = tl + (br - tl) * .99;

    await tester.tapAt(maxLight);
    expect(currentColor, equals(Colors.white));

    await tester.pump();

    final minLight = tl + (br - tl) * .01;
    await tester.tapAt(minLight);
    expect(currentColor, equals(Colors.black));
  });
}
