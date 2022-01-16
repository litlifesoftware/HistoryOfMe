part of api;

/// A `api` class allowing to validate and correct the current database
/// content to inconsistency or missing values.
///
/// Incorrect data could be creating whenever the `model` classes are altered
/// while the existing database still has the previous state.

class DatabaseStateValidator {
  final AppAPI api;

  /// Creates a [DatabaseStateValidator].
  const DatabaseStateValidator({
    required this.api,
  });

  /// Validates the current app settings box state.
  ///
  /// Updates the app settings box according to current requirements.
  void validateAppSettings(AppSettings appSettings) {
    if (appSettings.installationID == null) {
      print("`InstallationID` missing.");
      final _appSettings = AppSettings(
        privacyPolicyAgreed: appSettings.privacyPolicyAgreed,
        darkMode: appSettings.darkMode,
        tabIndex: appSettings.tabIndex,
        installationID: AppAPI.generateInstallationID(),
        lastBackup: appSettings.lastBackup,
      );
      api.updateAppSettings(_appSettings);
      print("`AppSettings` updated using generated `installationID`");
    }

    if (appSettings.lastBackup == null) {
      print("`lastBackup` missing.");
      final _appSettings = AppSettings(
        privacyPolicyAgreed: appSettings.privacyPolicyAgreed,
        darkMode: appSettings.darkMode,
        tabIndex: appSettings.tabIndex,
        installationID: appSettings.installationID,
        lastBackup: "",
      );
      api.updateAppSettings(_appSettings);
      print("`AppSettings` updated using empty date.");
    }
  }
}
