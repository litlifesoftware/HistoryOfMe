part of widgets;

class UpdatedLabelText extends StatelessWidget {
  final TextAlign textAlign;
  final TextStyle textStyle;

  final int? lastUpdateTimestamp;
  const UpdatedLabelText({
    Key? key,
    this.textAlign = TextAlign.left,
    required this.lastUpdateTimestamp,
    this.textStyle = LitSansSerifStyles.caption,
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
      style: textStyle,
    );
  }
}
