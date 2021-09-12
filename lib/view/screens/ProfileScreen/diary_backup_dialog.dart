import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:history_of_me/controller/controllers.dart';
import 'package:history_of_me/model/models.dart';
import 'package:history_of_me/view/provider/providers.dart';
import 'package:leitmotif/leitmotif.dart';
import 'package:lit_backup_service/lit_backup_service.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// A Flutter dialog widget allowing the user to create and manage backup files.
///
/// Each backup file is specific to one [installationID], due to it being used
/// in the backup file name.
class DiaryBackupDialog extends StatefulWidget {
  /// The current installation's id.
  ///
  /// Used for naming backup files.
  final String installationID;
  const DiaryBackupDialog({
    Key? key,
    required this.installationID,
  }) : super(key: key);

  @override
  _DiaryBackupDialogState createState() => _DiaryBackupDialogState();
}

class _DiaryBackupDialogState extends State<DiaryBackupDialog> {
  final HiveDBService _dbService = HiveDBService();
  late BackupStorage _backupStorage;
  late PackageInfo _packageInfo;

  /// Initializes the [_backupStorage].
  void _initBackupStorage() {
    _backupStorage = BackupStorage(
      organizationName: "LitLifeSoftware",
      applicationName: "HistoryOfMe",
      fileName: "historyofmebackup",
      installationID: widget.installationID,
    );
  }

  /// Initializes the [_packageInfo].
  Future<void> _initPackageInfo() async {
    var info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  /// Creates a backup file on the device's file storage and updates the
  /// meta data on the primary database.
  Future<void> _writeBackup(
    DiaryBackup backup,
    AppSettings appSettings,
  ) async {
    final DateTime now = DateTime.now();
    setState(
      () => {
        _backupStorage.writeBackup(backup),
      },
    );
    _dbService.updateLastBackup(appSettings, now);
  }

  /// Deletes the currently maintained backup file.
  Future<void> _deleteBackup() async {
    setState(
      () => {
        _backupStorage.deleteBackup(),
      },
    );
  }

  /// Returns a [DiaryBackup] (backup file content) using cleaned user data
  /// copies.
  ///
  /// The initial tap index will lead to the `ProfileScreen` to avoid the
  /// `HomeScreen` being rendered incorrectly on first startup after
  /// restoring the diary.
  DiaryBackup _getCleanBackup(
    AppSettings appSettings,
    List<DiaryEntry> diaryEntries,
    List<UserCreatedColor> userCreatedColors,
    UserData userData,
  ) {
    final cleanSettings = AppSettings(
      privacyPolicyAgreed: appSettings.privacyPolicyAgreed,
      darkMode: appSettings.privacyPolicyAgreed,
      tabIndex: 0,
      installationID: appSettings.installationID,
      lastBackup: "",
    );
    return DiaryBackup(
      appSettings: cleanSettings,
      diaryEntries: diaryEntries,
      userCreatedColors: userCreatedColors,
      userData: userData,
      appVersion: _packageInfo.version,
      backupDate: DateTime.now().toIso8601String(),
    );
  }

  /// Returns a [BackupModel] using the the currently maintained backup file's
  /// content.
  Future<BackupModel?> _readBackup() {
    return _backupStorage.readBackup(
      decode: (contents) => DiaryBackup.fromJson(
        jsonDecode(contents),
      ),
    );
  }

  /// Rebuilds the view using a simple `setState` call.
  void _rebuildView() {
    setState(() {});
  }

  /// Request all required permissions to access the local file storage.
  void _requestPermissions() {
    _backupStorage.requestPermissions().then((value) => _rebuildView());
  }

  @override
  void initState() {
    _initPackageInfo();
    _initBackupStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AllDataProvider(
      builder: (
        context,
        appSettings,
        userData,
        diaryEntries,
        userCreatedColors,
      ) {
        return FutureBuilder(
          future: _readBackup(),
          builder: (context, AsyncSnapshot<BackupModel?> snap) {
            if (snap.connectionState == ConnectionState.done) {
              if (snap.hasData) {
                DiaryBackup? diaryBackup = snap.data as DiaryBackup;

                return snap.data != null
                    ? _ManageBackupDialog(
                        diaryBackup: diaryBackup,
                        deleteBackup: _deleteBackup,
                        writeBackup: () => _writeBackup(
                          _getCleanBackup(
                            appSettings,
                            diaryEntries,
                            userCreatedColors,
                            userData,
                          ),
                          appSettings,
                        ),
                      )
                    : Text("Unsupported Backup!");
              }

              if (snap.hasError) return Text("Could load fetch diary backup!");
            } else if (snap.connectionState == ConnectionState.waiting) {
              return _LoadingBackupDialog();
            }

            return FutureBuilder(
              future: _backupStorage.hasPermissions(),
              builder: (context, AsyncSnapshot<bool> hasPerSnap) {
                print(hasPerSnap.data);
                if (hasPerSnap.hasData && hasPerSnap.data!) {
                  return _CreateBackupDialog(
                    writeBackup: () => _writeBackup(
                      _getCleanBackup(
                        appSettings,
                        diaryEntries,
                        userCreatedColors,
                        userData,
                      ),
                      appSettings,
                    ),
                  );
                }
                if (hasPerSnap.hasData && !hasPerSnap.data!) {
                  return _PermissionDeniedDialog(
                    onGrant: _requestPermissions,
                  );
                }
                return SizedBox();
              },
            );
          },
        );
      },
    );
  }
}

/// A Flutter widget displaying a placeholder dialog while loading content.
class _LoadingBackupDialog extends StatelessWidget {
  const _LoadingBackupDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: HOMLocalizations(context).loadingBackup,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 192.0),
          child: SizedBox(
            height: 64.0,
            width: 64.0,
            child: JugglingLoadingIndicator(
              indicatorColor: Colors.black,
              backgroundColor: Colors.white,
              shadowOpacity: 0.25,
            ),
          ),
        ),
      ),
    );
  }
}

/// A dialog widget allowing the user to grant the required permissions.
class _PermissionDeniedDialog extends StatelessWidget {
  final void Function() onGrant;
  const _PermissionDeniedDialog({
    Key? key,
    required this.onGrant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: HOMLocalizations(context).permissionsRequired,
      actionButtons: [
        DialogActionButton(
          label: HOMLocalizations(context).addPermissions,
          onPressed: onGrant,
        )
      ],
      child: ScrollableColumn(
        constrained: false,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        children: [
          _InfoDescription(),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
            ),
            child: Text(
              HOMLocalizations(context).permissionsRequiredDesc,
              style: LitSansSerifStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}

/// A dialog widget allowing the user to create a new backup.
class _CreateBackupDialog extends StatelessWidget {
  final void Function() writeBackup;

  const _CreateBackupDialog({
    Key? key,
    required this.writeBackup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: HOMLocalizations(context).noBackupFound,
      actionButtons: [
        DialogActionButton(
          label: HOMLocalizations(context).backupNow.toUpperCase(),
          onPressed: writeBackup,
        )
      ],
      child: ScrollableColumn(
        constrained: false,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 16.0,
            ),
            child: Text(
              HOMLocalizations(context).noBackupTitle,
              style: LitSansSerifStyles.body2,
            ),
          ),
          _InfoDescription(),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
            ),
            child: Text(
              HOMLocalizations(context).noBackupDescr,
              style: LitSansSerifStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}

/// A dialog widget allowing the user to manage an existing backup.
class _ManageBackupDialog extends StatelessWidget {
  final DiaryBackup diaryBackup;
  final void Function() deleteBackup;
  final void Function() writeBackup;
  const _ManageBackupDialog({
    Key? key,
    required this.diaryBackup,
    required this.deleteBackup,
    required this.writeBackup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      actionButtons: [
        DialogActionButton(
          label: HOMLocalizations(context).delete,
          onPressed: deleteBackup,
          backgroundColor: LitColors.lightPink,
          accentColor: Colors.white,
        ),
        DialogActionButton(
          label: HOMLocalizations(context).backupNowShort,
          onPressed: writeBackup,
        ),
      ],
      child: AllDataProvider(
        builder: (
          context,
          appSettings,
          userData,
          diaryEntries,
          userCreatedColors,
        ) {
          return _BackupPreview(
            diaryBackup: diaryBackup,
          );
        },
      ),
      titleText: HOMLocalizations(context).backupYourDiary,
    );
  }
}

/// A Flutter widget displaying a visual preview of the provided [DiaryBackup].
class _BackupPreview extends StatefulWidget {
  final DiaryBackup diaryBackup;
  const _BackupPreview({
    Key? key,
    required this.diaryBackup,
  }) : super(key: key);

  @override
  __BackupPreviewState createState() => __BackupPreviewState();
}

class __BackupPreviewState extends State<_BackupPreview> {
  @override
  Widget build(BuildContext context) {
    return ScrollableColumn(
      constrained: false,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      children: [
        _InfoDescription(),
        SizedBox(height: 16.0),
        _MetaDataItem(
          keyText: HOMLocalizations(context).installationID + ":",
          valueText: widget.diaryBackup.appSettings.installationID.toString(),
        ),
        _MetaDataItem(
          keyText: (HOMLocalizations(context).entires.capitalize()) + ":",
          valueText: widget.diaryBackup.diaryEntries.length.toString(),
        ),
        AnimatedRelativeDateTimeBuilder(
          date: DateTime.parse(widget.diaryBackup.backupDate),
          builder: (relDate, formatted) {
            return _MetaDataItem(
              keyText: (HOMLocalizations(context).lastBackup) + ":",
              valueText: DateTime.parse(widget.diaryBackup.backupDate)
                  .formatAsLocalizedDate(context),
              description: formatted,
            );
          },
        ),
        _UpToDateIndicator(
          diaryBackup: widget.diaryBackup,
        )
      ],
    );
  }
}

/// A Flutter widget displaying a text for what backups are used for.
class _InfoDescription extends StatelessWidget {
  const _InfoDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitDescriptionTextBox(
      padding: const EdgeInsets.all(0),
      text: HOMLocalizations(context).generalBackupDescr,
    );
  }
}

/// A Flutter widget visually indicating whether the provided [DiaryBackup] is
/// considered up-to-date.
class _UpToDateIndicator extends StatefulWidget {
  final DiaryBackup diaryBackup;
  const _UpToDateIndicator({
    Key? key,
    required this.diaryBackup,
  }) : super(key: key);

  @override
  __UpToDateIndicatorState createState() => __UpToDateIndicatorState();
}

class __UpToDateIndicatorState extends State<_UpToDateIndicator> {
  bool get _isUpToDate {
    const int MAX_DAYS_ALLOWED = 2;
    DateTime date = DateTime.parse(widget.diaryBackup.backupDate);
    int daysSinceBackup = DateTime.now().difference(date).inDays;

    return daysSinceBackup < MAX_DAYS_ALLOWED;
  }

  final Color _colorGood = Color(0xFFECFFE9);
  final Color _colorBad = Color(0xFFF2E4E4);
  final IconData _iconGood = LitIcons.check;
  final IconData _iconBad = LitIcons.times;

  Color get _color {
    return _isUpToDate ? _colorGood : _colorBad;
  }

  IconData get _icon {
    return _isUpToDate ? _iconGood : _iconBad;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                HOMLocalizations(context).upToDate,
                style: LitSansSerifStyles.subtitle2,
              ),
              Container(
                height: 32.0,
                width: 32.0,
                decoration: BoxDecoration(
                  color: _color,
                  boxShadow: LitBoxShadows.sm,
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _icon,
                    size: 13.0,
                    color: Color(0xFF616161),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: _isUpToDate
                ? Text(
                    HOMLocalizations(context).upToDateDescr,
                    style: LitSansSerifStyles.caption,
                  )
                : Text(
                    HOMLocalizations(context).notUpToDateDescr,
                    style: LitSansSerifStyles.caption.copyWith(
                      color: LitColors.darkRed,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// A Flutter widget displaying a named metadata value.
class _MetaDataItem extends StatelessWidget {
  final String keyText;
  final String valueText;
  final String? description;
  const _MetaDataItem({
    Key? key,
    required this.keyText,
    required this.valueText,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClippedText(
                keyText,
                style: LitSansSerifStyles.subtitle2,
              ),
              description != null ? Text("") : SizedBox()
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClippedText(
                valueText,
                style: LitSansSerifStyles.body2,
              ),
              description != null
                  ? ClippedText(
                      description!,
                      style: LitSansSerifStyles.caption,
                    )
                  : SizedBox()
            ],
          )
        ],
      ),
    );
  }
}
