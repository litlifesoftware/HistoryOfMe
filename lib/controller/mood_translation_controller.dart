import 'package:flutter/material.dart';

class MoodTranslationController {
  final double? moodScore;
  final String badMoodTranslation;
  final String mediumMoodTranslation;
  final String goodMoodTranslation;
  const MoodTranslationController({
    required this.moodScore,
    required this.badMoodTranslation,
    required this.mediumMoodTranslation,
    required this.goodMoodTranslation,
  });

  /// Returns a [String] describing the [moodScore] in a human readable label.
  String get translatedLabelText {
    if ((moodScore! > 0) & (moodScore! < 0.33)) {
      return badMoodTranslation;
    }
    if ((moodScore! > 0.33) & (moodScore! < 0.66)) {
      return mediumMoodTranslation;
    }
    if ((moodScore! > 0.66)) {
      return goodMoodTranslation;
    }
    return badMoodTranslation;
  }
}
