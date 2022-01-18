part of widgets;

/// A [LitBadge] widget displaying the total word count provided by the text
/// editing controller's current input value.
///
/// Applies validation to ensure only valid words are counted.
class WordCountBadge extends StatelessWidget {
  final TextEditingController controller;

  /// Creates a [WordCountBadge].
  const WordCountBadge({
    Key? key,
    required this.controller,
  }) : super(key: key);

  /// Returns the total word count.
  int get _totalWords => controller.text.wordCount;

  @override
  Widget build(BuildContext context) {
    return LitBadge(
      backgroundColor: LitColors.grey300,
      child: Text(
        _totalWords.toString() +
            " " +
            AppLocalizations.of(context).wordsWrittenLabel,
        style: LitSansSerifStyles.caption.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
