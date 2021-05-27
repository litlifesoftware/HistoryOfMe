import 'package:flutter/material.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';

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
      return HOMLocalizations(context).bad;
    }
    if ((moodScore! > 0.33) & (moodScore! < 0.66)) {
      return HOMLocalizations(context).alright;
    }
    if ((moodScore! > 0.66)) {
      return HOMLocalizations(context).good;
    }
    return HOMLocalizations(context).bad;
  }
}
