part of api;

/// A `api` class allowing to validate and correct the current database
/// content to prevent inconsistency or missing values.
///
/// Incorrect data could be created whenever the `model` classes are altered
/// while the existing database still contains the deprecated state.
///
/// Implement database-updating methods for each property added to the
/// `model` classes.

class DatabaseStateValidator {
  final AppAPI api;

  /// Creates a [DatabaseStateValidator].
  const DatabaseStateValidator({
    required this.api,
  });

  void createInstallationID(AppSettings appSettings) {
    final _appSettings = AppSettings(
      privacyPolicyAgreed: appSettings.privacyPolicyAgreed,
      darkMode: appSettings.darkMode,
      tabIndex: appSettings.tabIndex,
      installationID: AppAPI.generateInstallationID(),
      lastBackup: appSettings.lastBackup,
      backupNoticeIgnored: appSettings.backupNoticeIgnored,
    );
    api.updateAppSettings(_appSettings);
  }

  void createLastBackup(AppSettings appSettings) {
    final _appSettings = AppSettings(
      privacyPolicyAgreed: appSettings.privacyPolicyAgreed,
      darkMode: appSettings.darkMode,
      tabIndex: appSettings.tabIndex,
      installationID: appSettings.installationID,
      lastBackup: DefaultData.lastBackup,
      backupNoticeIgnored: appSettings.backupNoticeIgnored,
    );
    api.updateAppSettings(_appSettings);
  }

  void createBackupNoticeIgnored(AppSettings appSettings) {
    final _appSettings = AppSettings(
      privacyPolicyAgreed: appSettings.privacyPolicyAgreed,
      darkMode: appSettings.darkMode,
      tabIndex: appSettings.tabIndex,
      installationID: appSettings.installationID,
      lastBackup: appSettings.lastBackup,
      backupNoticeIgnored: DefaultData.backupNoticeIgnored,
    );
    api.updateAppSettings(_appSettings);
  }

  /// Validates the current app settings box state.
  ///
  /// Updates the app settings box according to current requirements.
  void validateAppSettings(AppSettings appSettings) {
    if (appSettings.installationID == null) {
      print("`InstallationID` setting missing.");
      createInstallationID(appSettings);
      print("`AppSettings` updated using generated `installationID`");
    }

    if (appSettings.lastBackup == null) {
      print("`lastBackup` setting missing.");
      createLastBackup(appSettings);
      print("`AppSettings` updated using default data.");
    }

    if (appSettings.backupNoticeIgnored == null) {
      print("`backupNoticeIgnored` setting missing.");
      createBackupNoticeIgnored(appSettings);
      print("`AppSettings` updated using default data.");
    }
  }
}
