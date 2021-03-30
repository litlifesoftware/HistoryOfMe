import 'package:flutter/material.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_slider_overlay.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_slider_thumb.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_slider_badge.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class LitSlider extends StatelessWidget {
  final double min;
  final double max;
  final double? value;
  final Color? activeTrackColor;
  final Color inactiveTrackColor;
  final Color? thumbColor;
  final void Function(double) onChanged;

  final double thumbHeight;
  final double thumbWidth;
  final double thumbRadius;
  final BoxShadow thumbBoxShadow;
  final double thumbFontSize;
  final Color thumbTextColor;
  final BoxShadow overlayBoxShadow;

  final bool displayValue;
  final bool displayRangeBadges;
  const LitSlider({
    required this.max,
    required this.min,
    required this.onChanged,
    required this.value,
    this.activeTrackColor = const Color(0xFFb5a0a0),
    this.inactiveTrackColor = const Color(0xFFf9dcdc),
    this.thumbColor = Colors.white,
    this.thumbHeight = 34.0,
    this.thumbWidth = 34.0,
    this.thumbRadius = 12.0,
    this.thumbBoxShadow = const BoxShadow(
      blurRadius: 12.0,
      color: Colors.black26,
      offset: Offset(2.0, 2.0),
      spreadRadius: 1.0,
    ),
    this.thumbFontSize = 15.0,
    this.thumbTextColor = LitColors.mediumGrey,
    this.overlayBoxShadow = const BoxShadow(
      blurRadius: 8.0,
      color: Colors.black38,
      offset: Offset(2.0, 2.0),
      spreadRadius: 1.0,
    ),
    this.displayValue = true,
    this.displayRangeBadges = true,
  });

  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: activeTrackColor,
            inactiveTrackColor: inactiveTrackColor,

            trackHeight: thumbHeight / 2,
            thumbShape: LitSliderThumb(
              color: thumbColor,
              min: min,
              max: max,
              height: thumbHeight,
              width: thumbWidth,
              radius: thumbRadius,
              boxShadow: thumbBoxShadow,
              fontSize: 14.0,
              textColor: Color.lerp(
                  Color.lerp(
                    thumbTextColor,
                    Colors.white,
                    0.5,
                  ),
                  thumbTextColor,
                  value! / max),
              displayValue: displayValue,
              fontWeight: FontWeight.w700,
            ),
            overlayShape: LitSliderOverlay(
              thumbHeight: thumbHeight,
              thumbWidth: thumbWidth,
              thumbRadius: thumbRadius,
              overlayBoxShadow: overlayBoxShadow,
            ),
            //trackShape: LitSliderTrack(),
            //valueIndicatorColor: Colors.white,
          ),
          child: Slider(max: max, min: min, value: value!, onChanged: onChanged),
        ),
        displayRangeBadges
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    LitTextBadge(
                      label: "${min.toInt()}",
                    ),
                    LitTextBadge(
                      label: "${max.toInt()}",
                    ),
                  ],
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
