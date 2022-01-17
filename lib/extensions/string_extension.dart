part of extensions;

/// Extension on [String] class.
///
/// Includes various methods for word counting.
extension StringExtension on String {
  // The pattern applied to split words inside the string.
  static const _wordSplitPattern = ' ';

  /// Validates whether the provided string does represent a valid word.
  ///
  /// Returns true if so.
  bool _validateWord(String word) {
    return word.isNotEmpty && !(word.contains(_wordSplitPattern));
  }

  /// Return the total number of words included in the string's value.
  int get wordCount {
    int counter = 0;

    // Iterate through the split string list and validate each item.
    for (String word in this.split(_wordSplitPattern)) {
      if (_validateWord(word)) {
        counter++;
      }
    }

    return counter;
  }
}
