import 'package:history_of_me/controller/controllers.dart';
import 'package:history_of_me/models.dart';

/// A `controller` class allowing to validate and correct the current database
/// content to inconsistency or missing values.
///
/// Incorrect data could be creating whenever the `model` classes are altered
/// while the existing database still has the previous state.

class DatabaseStateValidator {
  final HiveDBService dbService;

  /// Creates a [DatabaseStateValidator].
  const DatabaseStateValidator({
    required this.dbService,
  });

  void validateAppSettings(AppSettings appSettings) {
    if (appSettings.installationID == null) {
      print("`InstallationID` missing.");
      final _appSettings = AppSettings(
        privacyPolicyAgreed: appSettings.privacyPolicyAgreed,
        darkMode: appSettings.darkMode,
        tabIndex: appSettings.tabIndex,
        installationID: HiveDBService.createInstallationID(),
        lastBackup: appSettings.lastBackup,
      );
      dbService.updateAppSettings(_appSettings);
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
      dbService.updateAppSettings(_appSettings);
      print("`AppSettings` updated using empty date.");
    }
  }
}
