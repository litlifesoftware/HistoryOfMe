import 'package:flutter/material.dart';

class LitSliderOverlay extends SliderComponentShape {
  final double thumbHeight;
  final double thumbWidth;
  final double thumbRadius;
  final BoxShadow overlayBoxShadow;
  const LitSliderOverlay({
    required this.thumbHeight,
    required this.thumbWidth,
    required this.thumbRadius,
    required this.overlayBoxShadow,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(
      thumbWidth,
      thumbWidth,
    );
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
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final overlayPaint = Paint()
      ..color = overlayBoxShadow.color
      ..style = PaintingStyle.fill
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, overlayBoxShadow.blurRadius);

    //
    final RRect thumbOverlay = RRect.fromLTRBR(
      (center.dx - (thumbWidth / 2) + (overlayBoxShadow.offset.dx / 2)),
      (center.dy - (thumbHeight / 2) + (overlayBoxShadow.offset.dy / 2)),
      (center.dx + (thumbWidth / 2)) + (overlayBoxShadow.offset.dx / 2),
      (center.dy + (thumbHeight / 2) + (overlayBoxShadow.offset.dy / 2)),
      Radius.circular(thumbRadius),
    );

    canvas.drawRRect(thumbOverlay, overlayPaint);
  }
}
