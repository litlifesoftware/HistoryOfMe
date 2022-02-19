part of api;

/// A `api` widget allowing to query for a single [DiaryEntry] object by its
/// uid.
///
/// The builder method provides additional access to metadata required to
/// locate the object inside the collection.
///
/// Returns null if no diary entry has been found.
class QueryDiaryEntryProvider extends StatelessWidget {
  /// The [DiaryEntry]'s uid.
  ///
  /// Required to query the `Hive` database for a specific [DiaryEntry] object.
  final String diaryEntryUid;

  /// The builder method providing access to [DiaryEntry] objects.
  final Widget Function(
    BuildContext context,
    DiaryEntry? diaryEntry,
    bool isFirst,
    bool isLast,
    int boxLength,
  ) builder;

  /// The [AppAPI] instance.
  final AppAPI api;

  /// Creates a [DiaryEntryProvider].
  const QueryDiaryEntryProvider({
    Key? key,
    required this.diaryEntryUid,
    required this.builder,
    this.api = const AppAPI(),
  }) : super(key: key);

  /// Extracts the content stored inside the `Hive` box.
  DiaryEntry? extractContent(Box<DiaryEntry> box) {
    final DiaryEntry? diaryEntry = box.get(diaryEntryUid);

    return diaryEntry;
  }

  /// Returns the last entry's index.
  int getLastIndex(Box<DiaryEntry> box) {
    final int lastIndex = (box.length - 1);
    return lastIndex;
  }

  /// Returns the first entry's index.
  DiaryEntry? getFirstEntry(Box<DiaryEntry> box) {
    return box.isNotEmpty ? box.getAt(0) : null;
  }

  /// Returns whether the queried entry is stored on the first index.
  bool getIsFirstIndex(Box<DiaryEntry> box) {
    if (box.isEmpty) {
      return false;
    }

    DiaryEntry? first = getFirstEntry(box);

    if (first == null) return false;

    final bool? isFirst = first.uid == diaryEntryUid;

    return isFirst ?? false;
  }

  /// Returns whether the queried entry is stored on the last index.
  bool getIsLastIndex(Box<DiaryEntry> box) {
    if (box.isEmpty) {
      return false;
    }

    final bool? isFirst = box.getAt(getLastIndex(box))!.uid == diaryEntryUid;
    return isFirst ?? false;
  }

  /// Returns the provided [Box]'s length.
  int getBoxLenth(Box<DiaryEntry> box) {
    return box.length;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: api.getDiaryEntries(),
      builder: (BuildContext context, Box<DiaryEntry> box, Widget? _) {
        return builder(
          context,
          extractContent(box),
          getIsFirstIndex(box),
          getIsLastIndex(box),
          getBoxLenth(box),
        );
      },
    );
  }
}
