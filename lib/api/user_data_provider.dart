part of api;

/// A `api` widget providing [UserData] objects to the child widget accessed
/// by on the builder method.
///
/// Accessing the user data using this provider should only be done once the
/// user data is already present in the `Hive` database.
class UserDataProvider extends StatelessWidget {
  /// The builder method providing access to [AppSettings] object.
  final Widget Function(
    BuildContext context,
    UserData userData,
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
    // Try to retrieve the `AppSettings` instance
    try {
      final appSettings = box.getAt(0)!;
      return appSettings;
    } catch (e) {
      print(
          'Error while accessing the UserData object. Box content not found.');
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: api.getUserData(),
      builder: (context, Box<UserData> userDataBox, _) {
        return builder(
          context,
          extractContent(userDataBox)!,
        );
      },
    );
  }
}
