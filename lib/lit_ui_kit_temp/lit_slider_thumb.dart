import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class LitSliderThumb extends SliderComponentShape {
  final Color? color;
  final double height;
  final double width;
  final double radius;
  final double min;
  final double max;
  final BoxShadow boxShadow;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? textColor;
  final bool displayValue;
  const LitSliderThumb({
    required this.color,
    required this.height,
    required this.width,
    required this.radius,
    required this.min,
    required this.max,
    required this.boxShadow,
    required this.fontSize,
    required this.fontWeight,
    required this.textColor,
    required this.displayValue,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(width, height);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    required double value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint thumbPaint = Paint()
      ..color = color!
      ..style = PaintingStyle.fill;

    final Paint shadowPaint = Paint()
      ..color = boxShadow.color
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, boxShadow.blurRadius);

    final TextSpan text = TextSpan(
      style: LitTextStyles.sansSerif.copyWith(
        fontSize: fontSize,
        color: textColor,
        fontWeight: fontWeight,
      ),
      text: "${(min + (max - min) * value).floor()}",
    );

    final RRect thumb = RRect.fromLTRBR(
      (center.dx - (width / 2)),
      (center.dy - (height / 2)),
      (center.dx + (width / 2)),
      (center.dy + (height / 2)),
      Radius.circular(radius),
    );

    final RRect thumbShadow = RRect.fromLTRBR(
      (center.dx - (width / 2)) + (boxShadow.offset.dx / 2),
      (center.dy - (height / 2)) + (boxShadow.offset.dy / 2),
      (center.dx + (width / 2)) + (boxShadow.offset.dx / 2),
      (center.dy + (height / 2)) + (boxShadow.offset.dy / 2),
      Radius.circular(radius),
    );

    final TextPainter textPainter = TextPainter(
        text: text,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);

    // Calling the layout method is required before determining the center of the
    // text.
    textPainter.layout();

    final Offset textCenter = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );

    canvas.drawRRect(thumbShadow, shadowPaint);
    canvas.drawRRect(thumb, thumbPaint);

    if (displayValue) {
      textPainter.paint(canvas, textCenter);
    }
  }
}
