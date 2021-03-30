import 'package:flutter/material.dart';

/// An either brighter or darker [Color] version of the
/// provided [Color]. It will be interpolated using [Colors.black]
/// [Colors.white].
class InvertedColorBrightness extends Color {
  final Color baseColor;

  InvertedColorBrightness(this.baseColor)
      : super(Color.lerp(
          baseColor,
          _isBrightColor(baseColor) ? Colors.black : Colors.white,
          0.5,
        )!.value);

  /// Determine if the provided [Color] is either bright or
  /// dark by checking if its color channel values are above
  /// the midpoint of 127.
  static bool _isBrightColor(Color color) {
    return color.red > 127 && color.green > 127 ||
        color.green > 127 && color.blue > 127 ||
        color.red > 127 && color.blue > 127 ||
        color.green > 127;
  }
}
