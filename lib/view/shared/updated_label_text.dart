import 'package:flutter/material.dart';
import 'package:leitmotif/leitmotif.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';

class UpdatedLabelText extends StatelessWidget {
  final TextAlign textAlign;
  final double fontSize;
  final double letterSpacing;
  final FontWeight fontWeight;
  final Color textColor;
  final int? lastUpdateTimestamp;
  const UpdatedLabelText({
    Key? key,
    this.textAlign = TextAlign.left,
    this.fontSize = 12.4,
    this.letterSpacing = -0.22,
    this.fontWeight = FontWeight.w700,
    this.textColor = const Color(0xFFa5a5a5),
    required this.lastUpdateTimestamp,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final RelativeDateTime relativeDateTime = RelativeDateTime(
      dateTime: DateTime.now(),
      other: DateTime.fromMillisecondsSinceEpoch(lastUpdateTimestamp!),
    );
    final RelativeDateFormat relativeDateFormatter = RelativeDateFormat(
      Localizations.localeOf(context),
    );
    //final String formatter = DateFormat().toString();
    return ClippedText(
      "${relativeDateFormatter.format(relativeDateTime)}",
      textAlign: textAlign,
      style: LitTextStyles.sansSerif.copyWith(
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
        color: textColor,
      ),
    );
  }
}
