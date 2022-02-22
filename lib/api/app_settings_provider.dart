part of api;

/// A `api` widget providing [AppSettings] objects to the child widget accessed
/// by on the builder method.
class AppSettingsProvider extends StatelessWidget {
  /// The builder method providing access to [DiaryEntry] objects.
  final Widget Function(
    BuildContext context,
    AppSettings appSettings,
  ) builder;

  /// The [AppAPI] instance.
  final AppAPI api;

  /// The [DatabaseStateValidator] instance.
  final DatabaseStateValidator? validator;

  /// Creates a [AppSettingsProvider].
  const AppSettingsProvider({
    Key? key,
    required this.builder,
    this.api = const AppAPI(),
    this.validator,
  }) : super(key: key);

  /// Creates the initial [AppSettings] instance.
  void _createAppSettings() {
    api.createAppSettings();
  }

  /// Extracts the content stored inside the `Hive` box.
  AppSettings? extractContent(Box<AppSettings> box) {
    AppSettings? appSettings;
    // Try to retrieve the `AppSettings` instance
    try {
      appSettings = box.getAt(AppAPI.defaultEntryIndex);
      // If none found, return null.
      if (appSettings == null) return null;
      // Validate the app settings object to enforce data integrity.
      if (validator != null) validator!.validateAppSettings(appSettings);
    } catch (e) {
      print(e);
      _createAppSettings();
      print('Error while accessing AppSettings object. '
          'Creating backup AppSettings object ...');
    }
    return appSettings;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: api.getAppSettings(),
      builder: (context, Box<AppSettings> appSettingsBox, _) {
        return builder(
          context,
          extractContent(appSettingsBox) ?? api.defaultAppSettings,
        );
      },
    );
  }
}
