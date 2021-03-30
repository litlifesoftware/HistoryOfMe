import 'package:flutter/material.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_badge.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class LitTextBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final FontWeight fontWeight;
  final double fontSize;
  const LitTextBadge({
    Key? key,
    required this.label,
    this.backgroundColor = LitColors.mediumGrey,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w700,
    this.fontSize = 10.0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LitBadge(
      backgroundColor: backgroundColor,
      child: Text(
        "$label",
        style: LitTextStyles.sansSerif.copyWith(
          color: textColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
