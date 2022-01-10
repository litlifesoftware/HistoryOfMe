part of api;

/// An `api` widget allowing to pass all data stored on the `Hive` database
/// into a child widget using the [builder] method.
///
/// Accessing all data at once is rather expensive on memory but required to
/// e.g. create backupable objects.
class AllDataProvider extends StatefulWidget {
  /// `builder` method allowing to access all data available on its child.
  final Widget Function(
    BuildContext context,
    AppSettings appSettings,
    UserData? userData,
    List<DiaryEntry> diaryEntries,
    List<UserCreatedColor> userCreatedColors,
  ) builder;

  /// Creates an [AllDataProvider] that provides all data stored on the `Hive`
  /// database.
  const AllDataProvider({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  _AllDataProviderState createState() => _AllDataProviderState();
}

class _AllDataProviderState extends State<AllDataProvider> {
  /// The app api instance.
  final AppAPI _api = AppAPI();

  /// The database validator instance.
  late DatabaseStateValidator _validator;

  @override
  void initState() {
    _validator = DatabaseStateValidator(api: _api);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsProvider(
      validator: _validator,
      builder: (context, appSettings) {
        return UserDataProvider(
          builder: (context, userData) {
            return DiaryEntryProvider(
              builder: (context, diaryEntries) {
                return UserCreatedColorProvider(
                  builder: (context, userCreatedColors) {
                    return widget.builder(
                      context,
                      appSettings,
                      userData,
                      diaryEntries,
                      userCreatedColors,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
