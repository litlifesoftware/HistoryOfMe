part of api;

/// A `History of Me` `api` class containing default values applied on new
/// Hive box objects.
class DefaultData {
  static const int minStripeCount = 1;
  static int maxStripeCount = 32;
  static int minDotSize = 12;
  static int maxDotSize = 32;

  /// The initial quote.
  static const String quote =
      "The way to get started is to quit talking and begin doing.";

  /// The initial quote's author.
  static const String quoteAuthor = "Walt Disney";

  /// The initial design pattern index.
  static const int designPatternIndex = 0;

  /// The initial primary color value.
  static const int primaryColor = 0xFF757575;

  /// The initial secondary color value.
  static const int secondaryColors = 0xFFfff2b0;

  /// A list of initial user created color values.
  static const List<Color> userCreatedColorValues = [
    const Color(0xFFFAFAFA),
    const Color(0xFFF5F5F5),
    const Color(0xFFEEEEEE),
    const Color(0xFFE0E0E0),
    const Color(0xFFD6D6D6),
    const Color(0xFFBDBDBD),
    const Color(0xFF9E9E9E),
    const Color(0xFF757575),
    const Color(0xFF616161),
    const Color(0xFF424242),
    const Color(0xFF303030),
    const Color(0xFF212121),
    const Color(0xFFfff2b0),
  ];

  /// The default entry title.
  static const String diaryEntryTitle = "";

  /// the default entry content.
  static const String diaryEntryContent = "";

  /// The default diary entry's mood score.
  static const double diaryEntryMoodScore = 0.5;

  /// The default diary entry's backdrop id.
  static const int diaryEntryBackdropId = 1;

  static const bool agreedPrivacy = true;
  static const bool darkMode = false;
  static const int tabIndex = 0;
  static const String lastBackup = "";
  static const List<DiaryPhoto> photos = [];
  static const int visitCount = 0;
  static const int editCount = 0;
}
