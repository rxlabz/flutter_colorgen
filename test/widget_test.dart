// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rgb_hsl/color_pickers.dart';
import 'package:flutter_rgb_hsl/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ColorApp show color', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ColorApp());

    // Verify that our counter starts at 0.
    expect(find.text('#fff44336'), findsNWidgets(2));
  });

  testWidgets('HSLPicker max light show white', (WidgetTester tester) async {
    // Build our app and trigger a frame.
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
    final target = tl + (br - tl) * .99;
    await tester.tapAt(target);

    expect(currentColor, equals(Colors.white));
  });
}
