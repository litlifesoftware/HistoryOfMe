import 'package:flutter/material.dart';
import 'package:history_of_me/localization.dart';

class MoodTranslationController {
  final double? moodScore;
  final BuildContext context;
  const MoodTranslationController({
    required this.moodScore,
    required this.context,
  });

  /// Returns a [String] describing the [moodScore] in a human readable label.
  String get translatedLabelText {
    if ((moodScore! > 0) & (moodScore! < 0.33)) {
      return AppLocalizations.of(context).badLabel;
    }
    if ((moodScore! > 0.33) & (moodScore! < 0.66)) {
      return AppLocalizations.of(context).alrightLabel;
    }
    if ((moodScore! > 0.66)) {
      return AppLocalizations.of(context).goodLabel;
    }
    return AppLocalizations.of(context).badLabel;
  }

  /// Returns a label in 	in upper case.
  String get uppercaseLabel {
    return translatedLabelText.toUpperCase();
  }
}
