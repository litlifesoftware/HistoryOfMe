part of api;

/// A `api` widget providing [DiaryEntry] objects to the child widget accessed
/// by on the builder method.
class DiaryEntryProvider extends StatelessWidget {
  /// The builder method providing access to [DiaryEntry] objects.
  final Widget Function(
    BuildContext context,
    List<DiaryEntry> diaryEntries,
  ) builder;

  /// The [AppAPI] instance.
  final AppAPI api;

  /// Creates a [DiaryEntryProvider].
  const DiaryEntryProvider({
    Key? key,
    required this.builder,
    this.api = const AppAPI(),
  }) : super(key: key);

  /// Extracts the content stored inside the `Hive` box.
  List<DiaryEntry> extractContent(Box<DiaryEntry> box) {
    return box.isNotEmpty ? box.values.toList() : [];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: api.getDiaryEntries(),
      builder: (BuildContext context, Box<DiaryEntry> box, Widget? _) {
        return builder(
          context,
          extractContent(box),
        );
      },
    );
  }
}
