import 'package:flutter/material.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_slider.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class PatternConfigCard extends StatelessWidget {
  final String patternLabel;
  final int patternValue;
  final void Function(double) onPatternSliderChange;
  final int min;
  final int max;
  const PatternConfigCard({
    Key key,
    @required this.patternLabel,
    @required this.patternValue,
    @required this.onPatternSliderChange,
    @required this.min,
    @required this.max,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LitElevatedCard(
      child: LitSlider(
        max: max.toDouble(),
        min: min.toDouble(),
        onChanged: onPatternSliderChange,
        value: patternValue.toDouble(),
      ),
    );
  }
}
