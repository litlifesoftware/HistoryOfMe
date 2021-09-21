import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:history_of_me/app.dart';
import 'package:history_of_me/controller/controllers.dart';
import 'package:history_of_me/model/models.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:leitmotif/leitmotif.dart';
import 'package:lit_backup_service/lit_backup_service.dart';

import 'diary_preview_card.dart';
import 'cancel_restoring_dialog.dart';

/// A Flutter `screen` widget allowing to restore an existing backup by picking
/// a backup file located on the device storage.
class SelectBackupScreen extends StatefulWidget {
  /// Handes the `create new diary` action.
  final void Function() onCreateNewInstance;

  /// Creates a `SelectBackupScreen`.
  const SelectBackupScreen({
    Key? key,
    required this.onCreateNewInstance,
  }) : super(key: key);

  @override
  _SelectBackupScreenState createState() => _SelectBackupScreenState();
}

class _SelectBackupScreenState extends State<SelectBackupScreen> {
  /// States whether the database is currently being rebuilt.
  bool _isRebuilding = false;

  /// The currently cached [DiaryBackup].
  ///
  /// Remains `null` until a valid backup file has been picked and successfully
  /// decoded.
  DiaryBackup? _diaryBackup;

  late ScrollController _scrollController;

  late LitRouteController _routeController;

  late LitSnackbarController _snackbarController;

  final BackupStorage backupStorage = BackupStorage(
    organizationName: "LitLifeSoftware",
    applicationName: "HistoryOfMe",
    fileName: "historyofmebackup",

    /// Installation ID will not be required for restoring backups as due to
    /// the file location being provided by the user.
    installationID: "",
  );

  void _initRouteController() {
    _routeController = LitRouteController(context);
  }

  /// Toggles the [_isRebuilding] value.
  void _toggleIsBuildingDatabase() {
    setState(() {
      _isRebuilding = !_isRebuilding;
    });
  }

  /// Refreshes the view.
  void _refresh() {
    setState(() {});
  }

  /// Allows requesting all permissions required in order to access the
  /// device's local storage.
  Future<void> _requestPermissions() async {
    backupStorage.requestPermissions().then(
          (value) => _refresh(),
        );
  }

  /// Picks the backup file and decodes its content into a [DiaryBackup] object.
  ///
  /// Shows a snackbar once decoding the content has failed.
  void _pickFile() {
    backupStorage
        .pickBackupFile(
            decode: (contents) => DiaryBackup.fromJson(jsonDecode(contents)))
        .then(
      (value) {
        if (value == null) {
          setState(() {
            _snackbarController.showSnackBar();
          });
        } else {
          setState(() {
            _diaryBackup = value as DiaryBackup;
          });
        }
      },
    );
  }

  /// Rebuilds the `Hive` database using the provided [DiaryBackup] data.
  ///
  /// Restarts the app after successful rebuilding.
  Future<void> _rebuildDatabase(DiaryBackup backup) {
    _toggleIsBuildingDatabase();
    return HiveDBService()
        .rebuildDatabase(backup)
        .then((_) => _toggleIsBuildingDatabase())
        .then((_) => _routeController.clearNavigationStack())
        .then((_) => App.restartApp(context));
  }

  /// Handles the `create new diary` action and shows a dialog to confirm
  /// canceling the `restore` process.
  void _onCreateNewInstance() {
    _routeController.showDialogWidget(
      CancelRestoringDialog(
        onCancel: () {
          _routeController.closeDialog();
          widget.onCreateNewInstance();
        },
      ),
    );
  }

  @override
  void initState() {
    _initRouteController();
    _scrollController = ScrollController();
    _snackbarController = LitSnackbarController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LitScaffold(
      appBar: FixedOnScrollTitledAppbar(
        scrollController: _scrollController,
        title: HOMLocalizations(context).selectYourBackup,
      ),
      snackbars: [
        LitIconSnackbar(
          snackBarController: _snackbarController,
          text: HOMLocalizations(context).thisFileIsNotSupported,
          iconData: LitIcons.info,
        )
      ],
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LitGradients.greyGradient,
        ),
        child: ScrollableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          children: [
            LitScreenTitle(
              subtitle: HOMLocalizations(context).restoreFromBackup,
              title: HOMLocalizations(context).selectYourBackup,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  _BackupBuilder(
                    isRebuilding: _isRebuilding,
                    pickFile: _pickFile,
                    rebuildDatabase: _rebuildDatabase,
                    requestPermissions: _requestPermissions,
                    backupStorage: backupStorage,
                    diaryBackup: _diaryBackup,
                  ),
                  SizedBox(height: 24.0),
                  CreateNewActionCard(
                    onCreate: _onCreateNewInstance,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// A Flutter widget examining the current state and either ask the user about
/// requesting missing permissions or to provide a backup file.
///
/// If all required conditions are met, a backup preview is displayed.
class _BackupBuilder extends StatelessWidget {
  final BackupStorage backupStorage;
  final DiaryBackup? diaryBackup;
  final bool isRebuilding;
  final void Function() pickFile;
  final void Function() requestPermissions;
  final Future<void> Function(DiaryBackup backup) rebuildDatabase;
  const _BackupBuilder({
    Key? key,
    required this.backupStorage,
    required this.diaryBackup,
    required this.isRebuilding,
    required this.pickFile,
    required this.requestPermissions,
    required this.rebuildDatabase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: backupStorage.hasPermissions(),
      builder: (context, AsyncSnapshot<bool> hasPerSnap) {
        return hasPerSnap.hasData
            ? !hasPerSnap.data!
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        HOMLocalizations(context).readingBackupDenied,
                        style: LitSansSerifStyles.h6,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        HOMLocalizations(context).readingBackupDeniedDescr,
                        style: LitSansSerifStyles.body2,
                      ),
                      SizedBox(height: 8.0),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            child: LitPushedThroughButton(
                              onPressed: requestPermissions,
                              backgroundColor: Color(0xFFC7EBD3),
                              accentColor: Color(0xFFD7ECF4),
                              child: Text(
                                HOMLocalizations(context)
                                    .requestPermissions
                                    .toUpperCase(),
                                textAlign: TextAlign.center,
                                style: LitSansSerifStyles.button,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  )
                : Builder(
                    builder: (context) {
                      return isRebuilding
                          ? _LoadingCard()
                          : diaryBackup != null
                              ? DiaryPreviewCard(
                                  diaryBackup: diaryBackup!,
                                  rebuildDatabase: () =>
                                      rebuildDatabase(diaryBackup!),
                                )
                              : _BackupNotFoundCard(onPickFile: pickFile);
                    },
                  )
            : _LoadingCard();
      },
    );
  }
}

/// A `dialog` widget displaying a loading indicator.
class _LoadingCard extends StatelessWidget {
  const _LoadingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledActionCard(
      title: "",
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(height: 28.0),
              Center(
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
            ],
          );
        },
      ),
    );
  }
}

/// A `dialog` widget displaying informations to the user about how to read a
/// backup file from local storage and allowing to pick a file.
class _BackupNotFoundCard extends StatelessWidget {
  final void Function() onPickFile;
  const _BackupNotFoundCard({
    Key? key,
    required this.onPickFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledActionCard(
      title: HOMLocalizations(context).restoreFromFile,
      subtitle: HOMLocalizations(context).weNeedYourBackupFile,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(height: 16.0),
              Text(
                HOMLocalizations(context).pickFileDescr + ":",
                style: LitSansSerifStyles.body2,
              ),
              SizedBox(height: 8.0),
              _FilePathPreview(
                pathItems: [
                  "Download",
                  App.appDeveloper,
                  App.appName,
                  "historyofmebackup-ID.json",
                ],
              ),
            ],
          );
        },
      ),
      actionButtonData: [
        ActionButtonData(
          title: HOMLocalizations(context).pickFile,
          onPressed: onPickFile,
          backgroundColor: Colors.white,
          accentColor: Colors.white,
        )
      ],
    );
  }
}

// TODO: Move to Leitmotif
/// A Flutter widget displaying a horizontally scrollable file path preview.
class _FilePathPreview extends StatelessWidget {
  final List<String> pathItems;
  final EdgeInsets padding;
  const _FilePathPreview({
    Key? key,
    required this.pathItems,
    this.padding = const EdgeInsets.symmetric(horizontal: 2.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Builder(
        builder: (context) {
          List<Widget> children = [];
          for (int i = 0; i < pathItems.length; i++) {
            children.add(
              Text(
                pathItems[i],
                style: LitSansSerifStyles.overline,
              ),
            );
            if (i != (pathItems.length - 1)) {
              children.add(
                SizedBox(
                  child: Padding(
                    padding: padding,
                    child: Icon(
                      LitIcons.chevron_right_solid,
                      color: LitColors.lightGrey,
                      size: 10.0,
                    ),
                  ),
                ),
              );
            }
          }

          return Row(
            children: children,
          );
        },
      ),
    );
  }
}
