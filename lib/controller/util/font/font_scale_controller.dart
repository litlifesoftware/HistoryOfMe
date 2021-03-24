// import 'package:flutter/material.dart';

// /// Controlls the font scale factor in order to
// /// rescale fonts based on the device's screen
// /// resolution.
// class FontScaleController {
//   final BuildContext context;
//   final double basePixelRatio;
//   FontScaleController({@required this.context, @required this.basePixelRatio});

//   double adjustedFontSize(double baseFontSize) {
//     const minimunFontSize = 12.0;

//     /// The device's pixel ratio.
//     double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
//     double calculatedFontSize;

//     /// The baseFontSize will be set in relation to
//     /// the device's pixel ratio. The result will
//     /// then be multiplied to the base pixel ratio
//     /// to calculate the adjusted font size.
//     calculatedFontSize = baseFontSize / devicePixelRatio * basePixelRatio;
//     return calculatedFontSize < minimunFontSize
//         ? minimunFontSize
//         : calculatedFontSize;
//   }
// }
