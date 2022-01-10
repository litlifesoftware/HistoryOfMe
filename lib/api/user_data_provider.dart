part of api;

/// A `api` widget providing [UserData] objects to the child widget accessed
/// by on the builder method.
///
/// Accessing the user data using this provider should only be done once the
/// user data is already present in the `Hive` database.
class UserDataProvider extends StatelessWidget {
  /// The builder method providing access to the [UserData] object.
  ///
  /// The [isEmpty] values states whether the corresponding box is empty.
  final Widget Function(
    BuildContext context,
    UserData? userData,
  ) builder;

  /// The [AppAPI] instance.
  final AppAPI api;

  /// Creates a [UserDataProvider].
  const UserDataProvider({
    Key? key,
    required this.builder,
    this.api = const AppAPI(),
  }) : super(key: key);

  /// Extracts the content stored inside the `Hive` box.
  UserData? extractContent(Box<UserData> box) {
    return box.isEmpty ? null : box.getAt(0);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: api.getUserData(),
      builder: (context, Box<UserData> userDataBox, _) {
        return builder(
          context,
          extractContent(userDataBox),
        );
      },
    );
  }
}
