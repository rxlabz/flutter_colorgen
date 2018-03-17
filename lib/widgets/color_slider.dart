// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/widgets.dart';
import 'package:flutter_colorgen/color_utils.dart';
import 'package:color/color.dart' as colr;

class SquareSliderThumbShape extends SliderComponentShape {
  const SquareSliderThumbShape();
  static const double _thumbRadius = 6.0;
  static const double _disabledThumbRadius = 4.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return new Size.fromRadius(isEnabled ? _thumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    RenderBox parentBox,
    PaintingContext context,
    bool isDiscrete,
    Offset thumbCenter,
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    TextPainter labelPainter,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  ) {
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = new Tween<double>(
      begin: _disabledThumbRadius,
      end: _thumbRadius,
    );
    final ColorTween colorTween = new ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    canvas.drawRect(
      Rect.fromPoints(Offset(thumbCenter.dx - 3.0, thumbCenter.dy - 6.0),
          Offset(thumbCenter.dx + 3.0, thumbCenter.dy + 6.0)),
      /*Rect.fromCircle(
        center: thumbCenter, radius: radiusTween.evaluate(enableAnimation)),
      */
      new Paint()..color = colorTween.evaluate(enableAnimation),
    );
  }
}

class RoundColorSliderThumbShape extends SliderComponentShape {
  const RoundColorSliderThumbShape();

  static const double _thumbRadius = 6.0;
  static const double _disabledThumbRadius = 4.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return new Size.fromRadius(isEnabled ? _thumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    RenderBox parentBox,
    PaintingContext context,
    bool isDiscrete,
    Offset thumbCenter,
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    TextPainter labelPainter,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  ) {
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = new Tween<double>(
      begin: _disabledThumbRadius,
      end: _thumbRadius,
    );

    final rgb = colr.HslColor(360 * value, 80, 50).toRgbColor();
    final color = Color.fromRGBO(rgb.r, rgb.g, rgb.b, 1.0);
    final ColorTween colorTween = new ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: color ,
    );
    canvas.drawCircle(
      thumbCenter,
      radiusTween.evaluate(enableAnimation),
      new Paint()..color = colorTween.evaluate(enableAnimation),
    );
    canvas.drawCircle(
        thumbCenter,
        radiusTween.evaluate(enableAnimation),
        new Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0);
  }
}

class PaddleSliderColorValueIndicatorShape extends SliderComponentShape {
  const PaddleSliderColorValueIndicatorShape();

 static const double _topLobeRadius = 16.0;
  static const double _labelTextDesignSize = 14.0;
  static const double _bottomLobeRadius = 6.0;
  static const double _bottomLobeStartAngle = -1.1 * math.pi / 4.0;
  static const double _bottomLobeEndAngle = 1.1 * 5 * math.pi / 4.0;
  static const double _labelPadding = 8.0;
  static const double _distanceBetweenTopBottomCenters = 40.0;
  static const Offset _topLobeCenter = const Offset(0.0, -_distanceBetweenTopBottomCenters);
  static const double _topNeckRadius = 14.0;
  static const double _neckTriangleHypotenuse = _topLobeRadius + _topNeckRadius;
  // Some convenience values to help readability.
  static const double _twoSeventyDegrees = 3.0 * math.pi / 2.0;
  static const double _ninetyDegrees = math.pi / 2.0;
  static const double _thirtyDegrees = math.pi / 6.0;
  static const Size _preferredSize =
  const Size.fromHeight(_distanceBetweenTopBottomCenters + _topLobeRadius + _bottomLobeRadius);
  // Set to true if you want a rectangle to be drawn around the label bubble.
  // This helps with building tests that check that the label draws in the right
  // place (because it prints the rect in the failed test output). It should not
  // be checked in while set to "true".
  static const bool _debuggingLabelLocation = false;

  static Path _bottomLobePath; // Initialized by _generateBottomLobe
  static Offset _bottomLobeEnd; // Initialized by _generateBottomLobe

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => _preferredSize;

  // Adds an arc to the path that has the attributes passed in. This is
  // a convenience to make adding arcs have less boilerplate.
  static void _addArc(Path path, Offset center, double radius, double startAngle, double endAngle) {
    final Rect arcRect = new Rect.fromCircle(center: center, radius: radius);
    path.arcTo(arcRect, startAngle, endAngle - startAngle, false);
  }

  // Generates the bottom lobe path, which is the same for all instances of
  // the value indicator, so we reuse it for each one.
  static void _generateBottomLobe() {
    const double bottomNeckRadius = 4.5;
    const double bottomNeckStartAngle = _bottomLobeEndAngle - math.pi;
    const double bottomNeckEndAngle = 0.0;

    final Path path = new Path();
    final Offset bottomKnobStart = new Offset(
      _bottomLobeRadius * math.cos(_bottomLobeStartAngle),
      _bottomLobeRadius * math.sin(_bottomLobeStartAngle),
    );
    final Offset bottomNeckRightCenter = bottomKnobStart +
      new Offset(
        bottomNeckRadius * math.cos(bottomNeckStartAngle),
        -bottomNeckRadius * math.sin(bottomNeckStartAngle),
      );
    final Offset bottomNeckLeftCenter = new Offset(
      -bottomNeckRightCenter.dx,
      bottomNeckRightCenter.dy,
    );
    final Offset bottomNeckStartRight = new Offset(
      bottomNeckRightCenter.dx - bottomNeckRadius,
      bottomNeckRightCenter.dy,
    );
    path.moveTo(bottomNeckStartRight.dx, bottomNeckStartRight.dy);
    _addArc(
      path,
      bottomNeckRightCenter,
      bottomNeckRadius,
      math.pi - bottomNeckEndAngle,
      math.pi - bottomNeckStartAngle,
    );
    _addArc(
      path,
      Offset.zero,
      _bottomLobeRadius,
      _bottomLobeStartAngle,
      _bottomLobeEndAngle,
    );
    _addArc(
      path,
      bottomNeckLeftCenter,
      bottomNeckRadius,
      bottomNeckStartAngle,
      bottomNeckEndAngle,
    );

    _bottomLobeEnd = new Offset(
      -bottomNeckStartRight.dx,
      bottomNeckStartRight.dy,
    );
    _bottomLobePath = path;
  }

  Offset _addBottomLobe(Path path) {
    if (_bottomLobePath == null || _bottomLobeEnd == null) {
      // Generate this lazily so as to not slow down app startup.
      _generateBottomLobe();
    }
    path.extendWithPath(_bottomLobePath, Offset.zero);
    return _bottomLobeEnd;
  }

  // Determines the "best" offset to keep the bubble on the screen. The calling
  // code will bound that with the available movement in the paddle shape.
  double _getIdealOffset(
    RenderBox parentBox,
    double halfWidthNeeded,
    double scale,
    Offset center,
    ) {
    const double edgeMargin = 4.0;
    final Rect topLobeRect = new Rect.fromLTWH(
      -_topLobeRadius - halfWidthNeeded,
      -_topLobeRadius - _distanceBetweenTopBottomCenters,
      2.0 * (_topLobeRadius + halfWidthNeeded),
      2.0 * _topLobeRadius,
    );
    // We can just multiply by scale instead of a transform, since we're scaling
    // around (0, 0).
    final Offset topLeft = (topLobeRect.topLeft * scale) + center;
    final Offset bottomRight = (topLobeRect.bottomRight * scale) + center;
    double shift = 0.0;
    if (topLeft.dx < edgeMargin) {
      shift = edgeMargin - topLeft.dx;
    }
    if (bottomRight.dx > parentBox.size.width - edgeMargin) {
      shift = parentBox.size.width - bottomRight.dx - edgeMargin;
    }
    shift = (scale == 0.0 ? 0.0 : shift / scale);
    return shift;
  }

  void _drawValueIndicator(
    RenderBox parentBox,
    Canvas canvas,
    Offset center,
    Paint paint,
    double scale,
    TextPainter labelPainter,
    ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    // The entire value indicator should scale with the size of the label,
    // to keep it large enough to encompass the label text.
    final double textScaleFactor = labelPainter.height / _labelTextDesignSize;
    final double overallScale = scale * textScaleFactor;
    canvas.scale(overallScale, overallScale);
    final double inverseTextScale = textScaleFactor != 0 ? 1.0 / textScaleFactor : 0.0;
    final double labelHalfWidth = labelPainter.width / 2.0;

    // This is the needed extra width for the label.  It is only positive when
    // the label exceeds the minimum size contained by the round top lobe.
    final double halfWidthNeeded = math.max(
      0.0,
      inverseTextScale * labelHalfWidth - (_topLobeRadius - _labelPadding),
    );

    double shift = _getIdealOffset(parentBox, halfWidthNeeded, overallScale, center);
    double leftWidthNeeded;
    double rightWidthNeeded;
    if (shift < 0.0) {  // shifting to the left
      shift = math.max(shift, -halfWidthNeeded);
    } else {  // shifting to the right
      shift = math.min(shift, halfWidthNeeded);
    }
    rightWidthNeeded = halfWidthNeeded + shift;
    leftWidthNeeded = halfWidthNeeded - shift;

    final Path path = new Path();
    final Offset bottomLobeEnd = _addBottomLobe(path);

    // The base of the triangle between the top lobe center and the centers of
    // the two top neck arcs.
    final double neckTriangleBase = _topNeckRadius - bottomLobeEnd.dx;
    // The parameter that describes how far along the transition from round to
    // stretched we are.
    final double leftAmount = math.max(0.0, math.min(1.0, leftWidthNeeded / neckTriangleBase));
    final double rightAmount = math.max(0.0, math.min(1.0, rightWidthNeeded / neckTriangleBase));
    // The angle between the top neck arc's center and the top lobe's center
    // and vertical.
    final double leftTheta = (1.0 - leftAmount) * _thirtyDegrees;
    final double rightTheta = (1.0 - rightAmount) * _thirtyDegrees;
    // The center of the top left neck arc.
    final Offset neckLeftCenter = new Offset(
      -neckTriangleBase,
      _topLobeCenter.dy + math.cos(leftTheta) * _neckTriangleHypotenuse,
    );
    final Offset neckRightCenter = new Offset(
      neckTriangleBase,
      _topLobeCenter.dy + math.cos(rightTheta) * _neckTriangleHypotenuse,
    );
    final double leftNeckArcAngle = _ninetyDegrees - leftTheta;
    final double rightNeckArcAngle = math.pi + _ninetyDegrees - rightTheta;
    // The distance between the end of the bottom neck arc and the beginning of
    // the top neck arc. We use this to shrink/expand it based on the scale
    // factor of the value indicator.
    final double neckStretchBaseline = bottomLobeEnd.dy - math.max(neckLeftCenter.dy, neckRightCenter.dy);
    final double t = math.pow(inverseTextScale, 3.0);
    final double stretch = (neckStretchBaseline * t).clamp(0.0, 10.0 * neckStretchBaseline);
    final Offset neckStretch = new Offset(0.0, neckStretchBaseline - stretch);

    assert(!_debuggingLabelLocation || () {
      final Offset leftCenter = _topLobeCenter - new Offset(leftWidthNeeded, 0.0) + neckStretch;
      final Offset rightCenter = _topLobeCenter + new Offset(rightWidthNeeded, 0.0) + neckStretch;
      final Rect valueRect = new Rect.fromLTRB(
        leftCenter.dx - _topLobeRadius,
        leftCenter.dy - _topLobeRadius,
        rightCenter.dx + _topLobeRadius,
        rightCenter.dy + _topLobeRadius,
      );
      final Paint outlinePaint = new Paint()
        ..color = const Color(0xffff0000)
        ..style = PaintingStyle.stroke..strokeWidth = 1.0;
      canvas.drawRect(valueRect, outlinePaint);
      return true;
    }());

    _addArc(
      path,
      neckLeftCenter + neckStretch,
      _topNeckRadius,
      0.0,
      -leftNeckArcAngle,
    );
    _addArc(
      path,
      _topLobeCenter - new Offset(leftWidthNeeded, 0.0) + neckStretch,
      _topLobeRadius,
      _ninetyDegrees + leftTheta,
      _twoSeventyDegrees,
    );
    _addArc(
      path,
      _topLobeCenter + new Offset(rightWidthNeeded, 0.0) + neckStretch,
      _topLobeRadius,
      _twoSeventyDegrees,
      _twoSeventyDegrees + math.pi - rightTheta,
    );
    _addArc(
      path,
      neckRightCenter + neckStretch,
      _topNeckRadius,
      rightNeckArcAngle,
      math.pi,
    );
    canvas.drawPath(path, paint);

    // Draw the label.
    canvas.save();
    canvas.translate(shift, -_distanceBetweenTopBottomCenters + neckStretch.dy);
    canvas.scale(inverseTextScale, inverseTextScale);
    labelPainter.paint(canvas, Offset.zero - new Offset(labelHalfWidth, labelPainter.height / 2.0));
    canvas.restore();
    canvas.restore();
  }

  @override
  void paint(
    RenderBox parentBox,
    PaintingContext context,
    bool isDiscrete,
    Offset thumbCenter,
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    TextPainter labelPainter,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    ) {
    assert(labelPainter != null);

    final rgb = colr.HslColor(360 * value, 80, 50).toRgbColor();
    final color = Color.fromRGBO(rgb.r, rgb.g, rgb.b, 1.0);

    final ColorTween enableColor = new ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: color /*sliderTheme.valueIndicatorColor*/,
    );
    _drawValueIndicator(
      parentBox,
      context.canvas,
      thumbCenter,
      new Paint()..color = enableColor.evaluate(enableAnimation),
      activationAnimation.value,
      labelPainter,
    );
  }
}


class ColorGradientSlider extends StatefulWidget {
  const ColorGradientSlider({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.min: 0.0,
    this.max: 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
  })  : assert(value != null),
        assert(min != null),
        assert(max != null),
        assert(min <= max),
        assert(value >= min && value <= max),
        assert(divisions == null || divisions > 0),
        super(key: key);

  final double value;

  final ValueChanged<double> onChanged;

  final double min;

  final double max;

  final int divisions;

  final String label;

  // rm
  final Color activeColor;
  final Color inactiveColor;

  @override
  _SliderState createState() => new _SliderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(new DoubleProperty('value', value));
    description.add(new DoubleProperty('min', min));
    description.add(new DoubleProperty('max', max));
  }
}

class _SliderState extends State<ColorGradientSlider>
    with TickerProviderStateMixin {
  static const Duration enableAnimationDuration =
      const Duration(milliseconds: 75);
  static const Duration valueIndicatorAnimationDuration =
      const Duration(milliseconds: 100);

  // Animation controller that is run when the overlay (a.k.a radial reaction)
  // is shown in response to user interaction.
  AnimationController overlayController;
  // Animation controller that is run when the value indicator is being shown
  // or hidden.
  AnimationController valueIndicatorController;
  // Animation controller that is run when enabling/disabling the slider.
  AnimationController enableController;
  // Animation controller that is run when transitioning between one value
  // and the next on a discrete slider.
  AnimationController positionController;
  Timer interactionTimer;

  @override
  void initState() {
    super.initState();
    overlayController = new AnimationController(
      duration: kRadialReactionDuration,
      vsync: this,
    );
    valueIndicatorController = new AnimationController(
      duration: valueIndicatorAnimationDuration,
      vsync: this,
    );
    enableController = new AnimationController(
      duration: enableAnimationDuration,
      vsync: this,
    );
    positionController = new AnimationController(
      duration: Duration.zero,
      vsync: this,
    );
    // Create timer in a cancelled state, so that we don't have to
    // check for null below.
    interactionTimer = new Timer(Duration.zero, () {});
    interactionTimer.cancel();
    enableController.value = widget.onChanged != null ? 1.0 : 0.0;
    positionController.value = _unlerp(widget.value);
  }

  @override
  void dispose() {
    overlayController.dispose();
    valueIndicatorController.dispose();
    enableController.dispose();
    positionController.dispose();
    interactionTimer?.cancel();
    super.dispose();
  }

  void _handleChanged(double value) {
    assert(widget.onChanged != null);
    final double lerpValue = _lerp(value);
    if (lerpValue != widget.value) {
      widget.onChanged(lerpValue);
    }
  }

  // Returns a number between min and max, proportional to value, which must
  // be between 0.0 and 1.0.
  double _lerp(double value) {
    assert(value >= 0.0);
    assert(value <= 1.0);
    return value * (widget.max - widget.min) + widget.min;
  }

  // Returns a number between 0.0 and 1.0, given a value between min and max.
  double _unlerp(double value) {
    assert(value <= widget.max);
    assert(value >= widget.min);
    return widget.max > widget.min
        ? (value - widget.min) / (widget.max - widget.min)
        : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMediaQuery(context));

    SliderThemeData sliderTheme = SliderTheme.of(context);

    // If the widget has active or inactive colors specified, then we plug them
    // in to the slider theme as best we can. If the developer wants more
    // control than that, then they need to use a SliderTheme.
    if (widget.activeColor != null || widget.inactiveColor != null) {
      sliderTheme = sliderTheme.copyWith(
        activeRailColor: widget.activeColor,
        inactiveRailColor: widget.inactiveColor,
        activeTickMarkColor: widget.inactiveColor,
        inactiveTickMarkColor: widget.activeColor,
        thumbColor: widget.activeColor,
        valueIndicatorColor: widget.activeColor,
        overlayColor: widget.activeColor?.withAlpha(0x29),
      );
    }

    return new _SliderRenderObjectWidget(
      value: _unlerp(widget.value),
      divisions: widget.divisions,
      label: widget.label,
      sliderTheme: sliderTheme,
      mediaQueryData: MediaQuery.of(context),
      onChanged: (widget.onChanged != null) && (widget.max > widget.min)
          ? _handleChanged
          : null,
      state: this,
    );
  }
}

class _SliderRenderObjectWidget extends LeafRenderObjectWidget {
  const _SliderRenderObjectWidget({
    Key key,
    this.value,
    this.divisions,
    this.label,
    this.sliderTheme,
    this.mediaQueryData,
    this.onChanged,
    this.state,
  }) : super(key: key);

  final double value;
  final int divisions;
  final String label;
  final SliderThemeData sliderTheme;
  final MediaQueryData mediaQueryData;
  final ValueChanged<double> onChanged;
  final _SliderState state;

  @override
  _RenderSlider createRenderObject(BuildContext context) {
    return new _RenderSlider(
      value: value,
      divisions: divisions,
      label: label,
      sliderTheme: sliderTheme,
      theme: Theme.of(context),
      mediaQueryData: mediaQueryData,
      onChanged: onChanged,
      state: state,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSlider renderObject) {
    renderObject
      ..value = value
      ..divisions = divisions
      ..label = label
      ..sliderTheme = sliderTheme
      ..theme = Theme.of(context)
      ..mediaQueryData = mediaQueryData
      ..onChanged = onChanged
      ..textDirection = Directionality.of(context);
    // Ticker provider cannot change since there's a 1:1 relationship between
    // the _SliderRenderObjectWidget object and the _SliderState object.
  }
}

class _RenderSlider extends RenderBox {
  _RenderSlider({
    @required double value,
    int divisions,
    String label,
    SliderThemeData sliderTheme,
    ThemeData theme,
    MediaQueryData mediaQueryData,
    ValueChanged<double> onChanged,
    @required _SliderState state,
    @required TextDirection textDirection,
  })  : assert(value != null && value >= 0.0 && value <= 1.0),
        assert(state != null),
        assert(textDirection != null),
        _label = label,
        _value = value,
        _divisions = divisions,
        _sliderTheme = sliderTheme,
        _theme = theme,
        _mediaQueryData = mediaQueryData,
        _onChanged = onChanged,
        _state = state,
        _textDirection = textDirection {
    _updateLabelPainter();

    final GestureArenaTeam team = new GestureArenaTeam();

    _drag = new HorizontalDragGestureRecognizer()
      ..team = team
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _endInteraction;

    _tap = new TapGestureRecognizer()
      ..team = team
      ..onTapDown = _handleTapDown
      ..onTapUp = _handleTapUp
      ..onTapCancel = _endInteraction;

    _overlayAnimation = new CurvedAnimation(
      parent: _state.overlayController,
      curve: Curves.fastOutSlowIn,
    );
    _valueIndicatorAnimation = new CurvedAnimation(
      parent: _state.valueIndicatorController,
      curve: Curves.fastOutSlowIn,
    );
    _enableAnimation = new CurvedAnimation(
      parent: _state.enableController,
      curve: Curves.easeInOut,
    );
  }

  static const Duration _positionAnimationDuration =
      const Duration(milliseconds: 75);
  static const double _overlayRadius = 16.0;
  static const double _overlayDiameter = _overlayRadius * 2.0;
  static const double _railHeight = 12.0;
  static const double _preferredRailWidth = 144.0;
  static const double _preferredTotalWidth =
      _preferredRailWidth + _overlayDiameter;
  static const Duration _minimumInteractionTime =
      const Duration(milliseconds: 500);
  static const double _adjustmentUnit =
      0.1; // Matches iOS implementation of material slider.
  static final Tween<double> _overlayRadiusTween =
      new Tween<double>(begin: 0.0, end: _overlayRadius);

  _SliderState _state;
  Animation<double> _overlayAnimation;
  Animation<double> _valueIndicatorAnimation;
  Animation<double> _enableAnimation;
  final TextPainter _labelPainter = new TextPainter();
  HorizontalDragGestureRecognizer _drag;
  TapGestureRecognizer _tap;
  bool _active = false;
  double _currentDragValue = 0.0;

  double get _railLength => size.width - _overlayDiameter;

  bool get isInteractive => onChanged != null;

  bool get isDiscrete => divisions != null && divisions > 0;

  double get value => _value;
  double _value;
  set value(double newValue) {
    assert(newValue != null && newValue >= 0.0 && newValue <= 1.0);
    final double convertedValue = isDiscrete ? _discretize(newValue) : newValue;
    if (convertedValue == _value) {
      return;
    }
    _value = convertedValue;
    if (isDiscrete) {
      // Reset the duration to match the distance that we're traveling, so that
      // whatever the distance, we still do it in _positionAnimationDuration,
      // and if we get re-targeted in the middle, it still takes that long to
      // get to the new location.
      final double distance = (_value - _state.positionController.value).abs();
      _state.positionController.duration =
          distance != 0.0 ? _positionAnimationDuration * (1.0 / distance) : 0.0;
      _state.positionController
          .animateTo(convertedValue, curve: Curves.easeInOut);
    } else {
      _state.positionController.value = convertedValue;
    }
  }

  int get divisions => _divisions;
  int _divisions;
  set divisions(int value) {
    if (value == _divisions) {
      return;
    }
    _divisions = value;
    markNeedsPaint();
  }

  String get label => _label;
  String _label;
  set label(String value) {
    if (value == _label) {
      return;
    }
    _label = value;
    _updateLabelPainter();
  }

  SliderThemeData get sliderTheme => _sliderTheme;
  SliderThemeData _sliderTheme;
  set sliderTheme(SliderThemeData value) {
    if (value == _sliderTheme) {
      return;
    }
    _sliderTheme = value;
    markNeedsPaint();
  }

  ThemeData get theme => _theme;
  ThemeData _theme;
  set theme(ThemeData value) {
    if (value == _theme) {
      return;
    }
    _theme = value;
    markNeedsPaint();
  }

  MediaQueryData get mediaQueryData => _mediaQueryData;
  MediaQueryData _mediaQueryData;
  set mediaQueryData(MediaQueryData value) {
    if (value == _mediaQueryData) {
      return;
    }
    _mediaQueryData = value;
    // Media query data includes the textScaleFactor, so we need to update the
    // label painter.
    _updateLabelPainter();
  }

  ValueChanged<double> get onChanged => _onChanged;
  ValueChanged<double> _onChanged;
  set onChanged(ValueChanged<double> value) {
    if (value == _onChanged) {
      return;
    }
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      if (isInteractive) {
        _state.enableController.forward();
      } else {
        _state.enableController.reverse();
      }
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    assert(value != null);
    if (value == _textDirection) {
      return;
    }
    _textDirection = value;
    _updateLabelPainter();
  }

  bool get showValueIndicator {
    bool showValueIndicator;
    switch (_sliderTheme.showValueIndicator) {
      case ShowValueIndicator.onlyForDiscrete:
        showValueIndicator = isDiscrete;
        break;
      case ShowValueIndicator.onlyForContinuous:
        showValueIndicator = !isDiscrete;
        break;
      case ShowValueIndicator.always:
        showValueIndicator = true;
        break;
      case ShowValueIndicator.never:
        showValueIndicator = false;
        break;
    }
    return showValueIndicator;
  }

  void _updateLabelPainter() {
    final rgb = colr.HslColor(360 * value, 80, 50).toRgbColor();
    final color = Color.fromRGBO(rgb.r, rgb.g, rgb.b, 1.0);
    if (label != null) {
      _labelPainter
        ..text = new TextSpan(style: _theme.accentTextTheme.body2.copyWith(color: getContrastColor(color)), text: label)
        ..textDirection = textDirection
        ..textScaleFactor = _mediaQueryData.textScaleFactor
        ..layout();
    } else {
      _labelPainter.text = null;
    }
    // Changing the textDirection can result in the layout changing, because the
    // bidi algorithm might line up the glyphs differently which can result in
    // different ligatures, different shapes, etc. So we always markNeedsLayout.
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _overlayAnimation.addListener(markNeedsPaint);
    _valueIndicatorAnimation.addListener(markNeedsPaint);
    _enableAnimation.addListener(markNeedsPaint);
    _state.positionController.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _overlayAnimation.removeListener(markNeedsPaint);
    _valueIndicatorAnimation.removeListener(markNeedsPaint);
    _enableAnimation.removeListener(markNeedsPaint);
    _state.positionController.removeListener(markNeedsPaint);
    super.detach();
  }

  double _getValueFromVisualPosition(double visualPosition) {
    switch (textDirection) {
      case TextDirection.rtl:
        return 1.0 - visualPosition;
      case TextDirection.ltr:
        return visualPosition;
    }
    return null;
  }

  double _getValueFromGlobalPosition(Offset globalPosition) {
    final double visualPosition =
        (globalToLocal(globalPosition).dx - _overlayRadius) / _railLength;
    return _getValueFromVisualPosition(visualPosition);
  }

  double _discretize(double value) {
    double result = value.clamp(0.0, 1.0);
    if (isDiscrete) {
      result = (result * divisions).round() / divisions;
    }
    return result;
  }

  void _startInteraction(Offset globalPosition) {
    if (isInteractive) {
      _active = true;
      _currentDragValue = _getValueFromGlobalPosition(globalPosition);
      onChanged(_discretize(_currentDragValue));
      _state.overlayController.forward();
      if (showValueIndicator) {
        _state.valueIndicatorController.forward();
        if (_state.interactionTimer.isActive) {
          _state.interactionTimer.cancel();
        }
        _state.interactionTimer =
            new Timer(_minimumInteractionTime * timeDilation, () {
          if (!_active &&
              _state.valueIndicatorController.status ==
                  AnimationStatus.completed) {
            _state.valueIndicatorController.reverse();
          }
          _state.interactionTimer.cancel();
        });
      }
    }
  }

  void _endInteraction() {
    if (_active) {
      _active = false;
      _currentDragValue = 0.0;
      _state.overlayController.reverse();
      if (showValueIndicator && !_state.interactionTimer.isActive) {
        _state.valueIndicatorController.reverse();
      }
    }
  }

  void _handleDragStart(DragStartDetails details) =>
      _startInteraction(details.globalPosition);

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      final double valueDelta = details.primaryDelta / _railLength;
      switch (textDirection) {
        case TextDirection.rtl:
          _currentDragValue -= valueDelta;
          break;
        case TextDirection.ltr:
          _currentDragValue += valueDelta;
          break;
      }
      onChanged(_discretize(_currentDragValue));
    }
  }

  void _handleDragEnd(DragEndDetails details) => _endInteraction();

  void _handleTapDown(TapDownDetails details) =>
      _startInteraction(details.globalPosition);

  void _handleTapUp(TapUpDetails details) => _endInteraction();

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) {
      // We need to add the drag first so that it has priority.
      _drag.addPointer(event);
      _tap.addPointer(event);
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return math.max(
      _overlayDiameter,
      _sliderTheme.thumbShape.getPreferredSize(isInteractive, isDiscrete).width,
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    // This doesn't quite match the definition of computeMaxIntrinsicWidth,
    // but it seems within the spirit...
    return _preferredTotalWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) => _overlayDiameter;

  @override
  double computeMaxIntrinsicHeight(double width) => _overlayDiameter;

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = new Size(
      constraints.hasBoundedWidth ? constraints.maxWidth : _preferredTotalWidth,
      constraints.hasBoundedHeight ? constraints.maxHeight : _overlayDiameter,
    );
  }

  void _paintTickMarks(
    Canvas canvas,
    Rect railLeft,
    Rect railRight,
    Paint leftPaint,
    Paint rightPaint,
  ) {
    if (isDiscrete) {
      // The ticks are tiny circles that are the same height as the rail.
      const double tickRadius = _railHeight / 2.0;
      final double railWidth = railRight.right - railLeft.left;
      final double dx = (railWidth - _railHeight) / divisions;
      // If the ticks would be too dense, don't bother painting them.
      if (dx >= 3.0 * _railHeight) {
        for (int i = 0; i <= divisions; i += 1) {
          final double left = railLeft.left + i * dx;
          final Offset center =
              new Offset(left + tickRadius, railLeft.top + tickRadius);
          if (railLeft.contains(center)) {
            canvas.drawCircle(center, tickRadius, leftPaint);
          } else if (railRight.contains(center)) {
            canvas.drawCircle(center, tickRadius, rightPaint);
          }
        }
      }
    }
  }

  void _paintOverlay(Canvas canvas, Offset center) {
    if (!_overlayAnimation.isDismissed) {
      // TODO(gspencer) : We don't really follow the spec here for overlays.
      // The spec says to use 16% opacity for drawing over light material,
      // and 32% for colored material, but we don't really have a way to
      // know what the underlying color is, so there's no easy way to
      // implement this. Choosing the "light" version for now.
      final Paint overlayPaint = new Paint()..color = _sliderTheme.overlayColor;
      final double radius = _overlayRadiusTween.evaluate(_overlayAnimation);
      canvas.drawCircle(center, radius, overlayPaint);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final double railLength = size.width - 2 * _overlayRadius;
    final double value = _state.positionController.value;
    final ColorTween activeRailEnableColor = new ColorTween(
        begin: _sliderTheme.disabledActiveRailColor,
        end: _sliderTheme.activeRailColor);
    final ColorTween inactiveRailEnableColor = new ColorTween(
        begin: _sliderTheme.disabledInactiveRailColor,
        end: _sliderTheme.inactiveRailColor);
    final ColorTween activeTickMarkEnableColor = new ColorTween(
        begin: _sliderTheme.disabledActiveTickMarkColor,
        end: _sliderTheme.activeTickMarkColor);
    final ColorTween inactiveTickMarkEnableColor = new ColorTween(
        begin: _sliderTheme.disabledInactiveTickMarkColor,
        end: _sliderTheme.inactiveTickMarkColor);

    final Paint activeRailPaint = new Paint()
      ..color = activeRailEnableColor.evaluate(_enableAnimation);

    final Paint inactiveRailPaint = new Paint()
      ..color = inactiveRailEnableColor.evaluate(_enableAnimation);
    final Paint activeTickMarkPaint = new Paint()
      ..color = activeTickMarkEnableColor.evaluate(_enableAnimation);
    final Paint inactiveTickMarkPaint = new Paint()
      ..color = inactiveTickMarkEnableColor.evaluate(_enableAnimation);

    double visualPosition;
    Paint leftRailPaint;
    Paint rightRailPaint;
    Paint leftTickMarkPaint;
    Paint rightTickMarkPaint;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - value;
        leftRailPaint = inactiveRailPaint;
        rightRailPaint = activeRailPaint;
        leftTickMarkPaint = inactiveTickMarkPaint;
        rightTickMarkPaint = activeTickMarkPaint;
        break;
      case TextDirection.ltr:
        visualPosition = value;
        leftRailPaint = activeRailPaint;
        rightRailPaint = inactiveRailPaint;
        leftTickMarkPaint = activeTickMarkPaint;
        rightTickMarkPaint = inactiveTickMarkPaint;
        break;
    }

    const double railRadius = _railHeight / 2.0;
    const double thumbGap = 2.0;

    final double railVerticalCenter = offset.dy + (size.height) / 2.0;
    final double railLeft = offset.dx + _overlayRadius;
    final double railTop = railVerticalCenter - railRadius;
    final double railBottom = railVerticalCenter + railRadius;
    final double railRight = railLeft + railLength;
    final double railActive = railLeft + railLength * visualPosition;
    final double thumbRadius = _sliderTheme.thumbShape
            .getPreferredSize(isInteractive, isDiscrete)
            .width /
        2.0;
    final double railActiveLeft = math.max(0.0,
        railActive - thumbRadius - thumbGap * (1.0 - _enableAnimation.value));
    final double railActiveRight = math.min(
        railActive + thumbRadius + thumbGap * (1.0 - _enableAnimation.value),
        railRight);
    final Rect railLeftRect =
        new Rect.fromLTRB(railLeft, railTop, railActiveLeft, railBottom);
    final Rect railRightRect =
        new Rect.fromLTRB(railActiveRight, railTop, railRight, railBottom);

    final Offset thumbCenter = new Offset(railActive, railVerticalCenter);

    final Gradient gradient = new LinearGradient(
      colors: getHueGradientColors(),
    );
    Rect gradientRect = Rect.fromPoints(
        Offset(railLeft, railTop), Offset(railRight, railBottom));
    final gradientPaint = Paint()..shader = gradient.createShader(gradientRect);

    final Rect globalRect =
        new Rect.fromLTRB(railLeft, railTop, railRight, railBottom);
    canvas.drawRect(globalRect, gradientPaint);

    /*// Paint the rail.
    if (visualPosition > 0.0) {
      canvas.drawRect(railLeftRect, leftRailPaint);
    }
    if (visualPosition < 1.0) {
      canvas.drawRect(railRightRect, rightRailPaint);
    }*/

    _paintOverlay(canvas, thumbCenter);

    _paintTickMarks(
      canvas,
      railLeftRect,
      railRightRect,
      leftTickMarkPaint,
      rightTickMarkPaint,
    );

    if (isInteractive &&
        label != null &&
        _valueIndicatorAnimation.status != AnimationStatus.dismissed) {
      if (showValueIndicator) {
        _sliderTheme.valueIndicatorShape.paint(
          this,
          context,
          isDiscrete,
          thumbCenter,
          _valueIndicatorAnimation,
          _enableAnimation,
          _labelPainter,
          _sliderTheme,
          _textDirection,
          value,
        );
      }
    }

    _sliderTheme.thumbShape.paint(
      this,
      context,
      isDiscrete,
      thumbCenter,
      _overlayAnimation,
      _enableAnimation,
      label != null ? _labelPainter : null,
      _sliderTheme,
      _textDirection,
      value,
    );
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.isSemanticBoundary = isInteractive;
    if (isInteractive) {
      config.onIncrease = _increaseAction;
      config.onDecrease = _decreaseAction;
    }
  }

  double get _semanticActionUnit =>
      divisions != null ? 1.0 / divisions : _adjustmentUnit;

  void _increaseAction() {
    if (isInteractive) {
      onChanged((value + _semanticActionUnit).clamp(0.0, 1.0));
    }
  }

  void _decreaseAction() {
    if (isInteractive) {
      onChanged((value - _semanticActionUnit).clamp(0.0, 1.0));
    }
  }
}
