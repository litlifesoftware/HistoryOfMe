part of widgets;

class PatternConfigCard extends StatefulWidget {
  final int designPattern;
  //final String patternLabel;
  final int? patternValue;
  final void Function(double) onPatternSliderChange;
  final int min;
  final int max;
  const PatternConfigCard({
    Key? key,
    required this.designPattern,
    //required this.patternLabel,
    required this.patternValue,
    required this.onPatternSliderChange,
    required this.min,
    required this.max,
  }) : super(key: key);

  @override
  _PatternConfigCardState createState() => _PatternConfigCardState();
}

class _PatternConfigCardState extends State<PatternConfigCard> {
  bool get _showMetaData {
    return widget.designPattern == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: LitTitledActionCard(
        child: LitSlider(
          displayValue: _showMetaData,
          displayRangeBadges: _showMetaData,
          max: widget.max.toDouble(),
          min: widget.min.toDouble(),
          onChanged: widget.onPatternSliderChange,
          value: widget.patternValue!.toDouble(),
        ),
      ),
    );
  }
}
