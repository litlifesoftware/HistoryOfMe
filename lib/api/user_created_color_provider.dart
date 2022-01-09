part of api;

/// A `api` widget providing [UserCreatedColor] objects to the child widget
/// accessed by on the builder method.
class UserCreatedColorProvider extends StatelessWidget {
  /// The builder method providing access to [UserCreatedColor] objects.
  final Widget Function(
    BuildContext context,
    List<UserCreatedColor> userCreatedColors,
  ) builder;

  /// The [AppAPI] instance.
  final AppAPI api;

  /// Creates a [UserCreatedColorProvider].
  const UserCreatedColorProvider({
    Key? key,
    required this.builder,
    this.api = const AppAPI(),
  }) : super(key: key);

  /// Extracts the content stored inside the `Hive` box.
  List<UserCreatedColor> extractContent(Box<UserCreatedColor> box) {
    return box.isNotEmpty ? box.values.toList() : [];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: api.getUserCreatedColors(),
      builder: (
        BuildContext context,
        Box<UserCreatedColor> box,
        Widget? _,
      ) {
        return builder(
          context,
          extractContent(box),
        );
      },
    );
  }
}
