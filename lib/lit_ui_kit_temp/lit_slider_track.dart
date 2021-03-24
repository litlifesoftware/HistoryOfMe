// import 'package:flutter/material.dart';

// class LitSliderTrack extends SliderTrackShape {
//   const LitSliderTrack({this.disabledThumbGapWidth = 2.0, this.radius = 8.0});

//   final double disabledThumbGapWidth;
//   final double radius;

//   @override
//   Rect getPreferredRect({
//     RenderBox parentBox,
//     Offset offset = Offset.zero,
//     SliderThemeData sliderTheme,
//     bool isEnabled,
//     bool isDiscrete,
//   }) {
//     final double overlayWidth =
//         sliderTheme.overlayShape.getPreferredSize(isEnabled, isDiscrete).width;
//     final double trackHeight = sliderTheme.trackHeight;
//     assert(overlayWidth >= 0);
//     assert(trackHeight >= 0);
//     assert(parentBox.size.width >= overlayWidth);
//     assert(parentBox.size.height >= trackHeight);

//     final double trackLeft = offset.dx + overlayWidth / 2;
//     final double trackTop =
//         offset.dy + (parentBox.size.height - trackHeight) / 2;

//     final double trackWidth = parentBox.size.width - overlayWidth;
//     return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
//   }

//   @override
//   void paint(
//     PaintingContext context,
//     Offset offset, {
//     RenderBox parentBox,
//     SliderThemeData sliderTheme,
//     Animation<double> enableAnimation,
//     TextDirection textDirection,
//     Offset thumbCenter,
//     bool isDiscrete,
//     bool isEnabled,
//   }) {
//     if (sliderTheme.trackHeight == 0) {
//       return;
//     }

//     final ColorTween activeTrackColorTween = ColorTween(
//         begin: sliderTheme.disabledActiveTrackColor,
//         end: sliderTheme.activeTrackColor);
//     final ColorTween inactiveTrackColorTween = ColorTween(
//         begin: sliderTheme.disabledInactiveTrackColor,
//         end: sliderTheme.inactiveTrackColor);
//     final Paint activePaint = Paint()
//       ..color = activeTrackColorTween.evaluate(enableAnimation);
//     final Paint inactivePaint = Paint()
//       ..color = inactiveTrackColorTween.evaluate(enableAnimation);
//     Paint leftTrackPaint;
//     Paint rightTrackPaint;
//     switch (textDirection) {
//       case TextDirection.ltr:
//         leftTrackPaint = activePaint;
//         rightTrackPaint = inactivePaint;
//         break;
//       case TextDirection.rtl:
//         leftTrackPaint = inactivePaint;
//         rightTrackPaint = activePaint;
//         break;
//     }

//     double horizontalAdjustment = 0.0;
//     if (!isEnabled) {
//       final double disabledThumbRadius =
//           sliderTheme.thumbShape.getPreferredSize(false, isDiscrete).width /
//               2.0;
//       final double gap = disabledThumbGapWidth * (1.0 - enableAnimation.value);
//       horizontalAdjustment = disabledThumbRadius + gap;
//     }

//     final Rect trackRect = getPreferredRect(
//       parentBox: parentBox,
//       offset: offset,
//       sliderTheme: sliderTheme,
//       isEnabled: isEnabled,
//       isDiscrete: isDiscrete,
//     );
//     //Modify this side
//     final RRect leftTrackSegment = RRect.fromLTRBR(
//         trackRect.left,
//         trackRect.top,
//         thumbCenter.dx - horizontalAdjustment,
//         trackRect.bottom,
//         Radius.circular(radius));
//     context.canvas.drawRRect(leftTrackSegment, leftTrackPaint);
//     final RRect rightTrackSegment = RRect.fromLTRBR(
//         thumbCenter.dx + horizontalAdjustment,
//         trackRect.top,
//         trackRect.right,
//         trackRect.bottom,
//         Radius.circular(radius));
//     context.canvas.drawRRect(rightTrackSegment, rightTrackPaint);
//   }
// }
