part of controllers;

/// A `controller` class translating the provided [moodScore] into a human
/// readable label.
class MoodTranslator {
  /// The current [BuildContext].
  final BuildContext context;

  /// A list of mood labels sorted accending according to the corresponding
  /// [moodScore] it should represent.
  ///
  /// Applies default labels if none are provided.
  final List<String>? labels;

  /// The current mood score.
  final double moodScore;
  const MoodTranslator({
    required this.moodScore,
    required this.context,
    this.labels,
  });

  /// A list of mood labels sorted accending according to the corresponding
  /// [moodScore] it should represent.
  List<String> get _labels =>
      labels ??
      [
        AppLocalizations.of(context).badLabel,
        AppLocalizations.of(context).mixedLabel,
        AppLocalizations.of(context).alrightLabel,
        AppLocalizations.of(context).goodLabel,
      ];

  /// Returns a [String] translating the [moodScore] into a human readable
  /// label.
  String get label {
    for (int i = 0; i < _labels.length; i++) {
      // States the limit the score should not exceed in order to fit
      // the value.
      double limit = (i + 1) / _labels.length;
      if (moodScore < limit) {
        return _labels[i];
      }
    }

    return _labels.last;
  }
}
