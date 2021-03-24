// import 'package:flutter/material.dart';

// /// Widget to replace Flutter's color addressing
// /// with the common hex value.
// /// The hex color is pared as a String.
// class HexColor extends Color {
//   final String hexColor;

//   /// The constructor will execute the
//   /// [_convertHexColor] which will return
//   /// the desired integer representing
//   /// the color value.
//   HexColor(this.hexColor) : super(_convertHexColor(hexColor));
//   //
//   static int _convertHexColor(String hexColor) {
//     hexColor = hexColor.toUpperCase().replaceAll('#', '');
//     if (hexColor.length == 6) {
//       hexColor = 'FF' + hexColor;
//     }
//     return int.parse(hexColor, radix: 16);
//   }
// }
