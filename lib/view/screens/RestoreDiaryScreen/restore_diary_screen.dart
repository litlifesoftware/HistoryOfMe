import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:history_of_me/app.dart';
import 'package:history_of_me/controller/controllers.dart';
import 'package:history_of_me/model/models.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:leitmotif/leitmotif.dart';
import 'package:lit_backup_service/lit_backup_service.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';

/// TODO: Move to `Leitmotif`
const _BACKGROUNDDECORATION = BoxDecoration(
  gradient: const LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: const [
      const Color(0xFFFDFDFD),
      const Color(0xFFDEDEDE),
    ],
  ),
);

/// A Flutter widget allowing to restore an existing diary by reading its backup
/// file or to create a new diary if restoring the diary is not possible.
///
class RestoreDiaryScreen extends StatefulWidget {
  final void Function() onCreateNewInstance;

  const RestoreDiaryScreen({
    Key? key,
    required this.onCreateNewInstance,
  }) : super(key: key);

  @override
  _RestoreDiaryScreenState createState() => _RestoreDiaryScreenState();
}

class _RestoreDiaryScreenState extends State<RestoreDiaryScreen> {
  @override
  Widget build(BuildContext context) {
    return _SelectCreateModeScreen(
      onCreateNewInstance: widget.onCreateNewInstance,
    );
  }
}

class _SelectBackupScreen extends StatefulWidget {
  final void Function() onCreateNewInstance;

  const _SelectBackupScreen({
    Key? key,
    required this.onCreateNewInstance,
  }) : super(key: key);

  @override
  __SelectBackupScreenState createState() => __SelectBackupScreenState();
}

class __SelectBackupScreenState extends State<_SelectBackupScreen> {
  final BackupStorage backupStorage = BackupStorage(
    organizationName: "LitLifeSoftware",
    applicationName: "HistoryOfMe",
    fileName: "historyofmebackup",

    /// Installation ID will not be required for restoring backups as due to
    /// the file location being provided by the user.
    installationID: "",
  );

  late LitRouteController _routeController;

  bool _isRebuildingDatabase = false;

  DiaryBackup? _backupModel;

  late LitSnackbarController _snackbarController;

  void _initRouteController() {
    _routeController = LitRouteController(context);
  }

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
            _backupModel = value as DiaryBackup;
          });
        }
      },
    );
  }

  Future<void> _requestPermissions() async {
    backupStorage.requestPermissions().then(
          (value) => _rebuildView(),
        );
  }

  void _rebuildView() {
    setState(() {});
  }

  void _navigate() {
    _routeController.closeDialog();
    widget.onCreateNewInstance();
  }

  void _toggleIsBuildingDatabase() {
    setState(() {
      _isRebuildingDatabase = !_isRebuildingDatabase;
    });
  }

  Future<void> _rebuildDatabase(DiaryBackup backup) {
    _toggleIsBuildingDatabase();
    return HiveDBService()
        .rebuildDatabase(backup)
        .then((_) => _toggleIsBuildingDatabase())
        .then((_) => _routeController.clearNavigationStack())
        .then((_) => App.restartApp(context));
  }

  void _onCreateNewInstance() {
    _routeController.showDialogWidget(
      LitTitledDialog(
        child: LitDescriptionTextBox(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          text:
              "Do you want to create a new diary instead of restoring your old one?",
        ),
        titleText: "Create new diary?",
        actionButtons: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LitPushedThroughButton(
              child: Text(
                "Create new".toUpperCase(),
                style: LitSansSerifStyles.button,
                textAlign: TextAlign.center,
              ),
              onPressed: _navigate,
            ),
          )
        ],
      ),
    );

    // widget.onCreateNewInstance();
  }

  @override
  void initState() {
    _initRouteController();
    _snackbarController = LitSnackbarController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LitScaffold(
      snackbars: [
        LitIconSnackbar(
          snackBarController: _snackbarController,
          text: "This backup file is not supported. Please try another one.",
          iconData: LitIcons.info,
        )
      ],
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: _BACKGROUNDDECORATION,
        child: ScrollableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          children: [
            LitScreenTitle(
              subtitle: "Restore from backup",
              title: "Select your backup",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30.0,
              ),
              child: Column(
                children: [
                  FutureBuilder(
                    future: backupStorage.hasPermissions(),
                    builder: (context, AsyncSnapshot<bool> hasPerSnap) {
                      return hasPerSnap.hasData
                          ? !hasPerSnap.data!
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Reading backup denied.",
                                      style: LitSansSerifStyles.h6,
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      "History of Me needs additional permissions in order to access your storage. This will be required to read your diary backup.",
                                      style: LitSansSerifStyles.body2,
                                    ),
                                    SizedBox(height: 8.0),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        return SizedBox(
                                          width: constraints.maxWidth,
                                          child: LitPushedThroughButton(
                                            onPressed: _requestPermissions,
                                            backgroundColor: Color(0xFFC7EBD3),
                                            accentColor: Color(0xFFD7ECF4),
                                            child: Text(
                                              "Request permissions"
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
                              : Builder(builder: (context) {
                                  return _isRebuildingDatabase
                                      ? SizedBox(
                                          height: 275.0,
                                          child: Center(
                                            child: SizedBox(
                                              height: 54.0,
                                              width: 54.0,
                                              child: JugglingLoadingIndicator(
                                                backgroundColor: Colors.white,
                                                indicatorColor: Colors.grey,
                                                shadowOpacity: 0.25,
                                              ),
                                            ),
                                          ),
                                        )
                                      : _backupModel != null
                                          ? _DiaryPreviewCard(
                                              diaryBackup: _backupModel!,
                                              rebuildDatabase: () =>
                                                  _rebuildDatabase(
                                                      _backupModel!),
                                            )
                                          : _BackupNotFoundCard(
                                              onPickFile: _pickFile,
                                            );
                                })
                          : _LoadingCard();
                    },
                  ),
                  SizedBox(height: 24.0),
                  _CreateNewActionCard(
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

class _DiaryPreviewCard extends StatelessWidget {
  final DiaryBackup diaryBackup;
  final Future Function() rebuildDatabase;
  const _DiaryPreviewCard({
    Key? key,
    required this.diaryBackup,
    required this.rebuildDatabase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledActionCard(
      title: "We found your diary",
      subtitle: "Continue your journey",
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              LayoutBuilder(
                builder: (constex, constraints) {
                  return Row(
                    children: [
                      SizedBox(
                        height: 48.0,
                        width: 48.0,
                        child: UserIcon(
                          size: 48.0,
                          userData: diaryBackup.userData,
                        ),
                      ),
                      SizedBox(
                        height: 48.0,
                        width: constraints.maxWidth - 48.0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            top: 2.0,
                            bottom: 2.0,
                            right: 2.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                diaryBackup.userData.name + "'s diary",
                                style: LitSansSerifStyles.subtitle2,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "History of Me",
                                      style: LitSansSerifStyles.caption,
                                    ),
                                    TextSpan(
                                      text: " ${diaryBackup.appVersion}",
                                      style:
                                          LitSansSerifStyles.caption.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              BookmarkFront(
                userData: diaryBackup.userData,
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total entries: ",
                    style: LitSansSerifStyles.body2,
                  ),
                  LitBadge(
                    borderRadius: BorderRadius.circular(16.0),
                    backgroundColor: LitColors.lightGrey,
                    child: Text(
                      diaryBackup.diaryEntries.length.toString(),
                      style: LitSansSerifStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Last updated: ",
                    style: LitSansSerifStyles.body2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateTime.parse(diaryBackup.backupDate)
                            .formatAsLocalizedDateTime(context),
                        style: LitSansSerifStyles.subtitle1,
                      ),
                      _FormattedRelativeDateTimeBuilder(
                        date: DateTime.parse(diaryBackup.backupDate),
                        builder: (formatted) {
                          return Text(
                            formatted,
                            style: LitSansSerifStyles.caption,
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ],
          );
        },
      ),
      actionButtonData: [
        ActionButtonData(
          title: "RESTORE DIARY".toUpperCase(),
          onPressed: rebuildDatabase,
          backgroundColor: Color(0xFFC7EBD3),
          accentColor: Color(0xFFD7ECF4),
        ),
      ],
    );
  }
}

class _FormattedRelativeDateTimeBuilder extends StatelessWidget {
  final DateTime date;
  final Widget Function(String formattedRelativeDateTime) builder;
  const _FormattedRelativeDateTimeBuilder({
    Key? key,
    required this.builder,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final RelativeDateTime relativeDateTime = RelativeDateTime(
          dateTime: DateTime.now(),
          other: date,
        );
        final RelativeDateFormat relativeDateFormatter = RelativeDateFormat(
          Localizations.localeOf(context),
        );
        return builder(
          relativeDateFormatter.format(relativeDateTime),
        );
      },
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledActionCard(
      title: "Reading backup",
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
    // return Container(
    //   height: 512,
    //   width: 512,
    //   color: Colors.black,
    // );
  }
}

class _BackupNotFoundCard extends StatelessWidget {
  final void Function() onPickFile;
  const _BackupNotFoundCard({
    Key? key,
    required this.onPickFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledActionCard(
      title: "Restore from file",
      subtitle: "We need your backup file",
      actionButtonData: [
        ActionButtonData(
          title: "PICK FILE",
          onPressed: onPickFile,
          backgroundColor: Colors.white,
          accentColor: Colors.white,
        )
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(height: 16.0),
              Text(
                "Please provide your your backup file. Backup files have a unique file name and are usually stored in your 'Download' folder on this location:",
                style: LitSansSerifStyles.body2,
              ),
              SizedBox(height: 8.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: [
                    Text(
                      "Download",
                      style: LitSansSerifStyles.overline,
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(
                          LitIcons.chevron_right_solid,
                          color: LitColors.lightGrey,
                          size: 10.0,
                        ),
                      ),
                    ),
                    Text(
                      "LitLifeSoftware",
                      style: LitSansSerifStyles.overline,
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(
                          LitIcons.chevron_right_solid,
                          color: LitColors.lightGrey,
                          size: 10.0,
                        ),
                      ),
                    ),
                    Text(
                      "HistoryOfMe",
                      style: LitSansSerifStyles.overline,
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(
                          LitIcons.chevron_right_solid,
                          color: LitColors.lightGrey,
                          size: 10.0,
                        ),
                      ),
                    ),
                    Text(
                      "historyofmebackup-YOURID.json",
                      style: LitSansSerifStyles.overline,
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
    // Column(
    //   children: [
    //     Text(
    //       "Backup not found!",
    //     ),
    //     ElevatedButton(
    //       onPressed: onRefresh,
    //       child: Icon(
    //         Icons.refresh,
    //       ),
    //     )
    //   ],
    // );
  }
}

class _SelectCreateModeScreen extends StatefulWidget {
  final void Function() onCreateNewInstance;
  const _SelectCreateModeScreen({
    Key? key,
    required this.onCreateNewInstance,
  }) : super(key: key);

  @override
  __SelectCreateModeScreenState createState() =>
      __SelectCreateModeScreenState();
}

class __SelectCreateModeScreenState extends State<_SelectCreateModeScreen> {
  late LitRouteController _routeController;

  void onRestoreBackup() {
    _routeController.pushCupertinoWidget(_SelectBackupScreen(
      onCreateNewInstance: widget.onCreateNewInstance,
    ));
  }

  @override
  void initState() {
    _routeController = LitRouteController(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LitScaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFFDFDFD),
              Color(0xFFDEDEDE),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LitScreenTitle(
                title: "New Diary",
                subtitle: "Create a new diary",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30.0,
                ),
                child: Column(
                  children: [
                    _CreateNewActionCard(
                      onCreate: widget.onCreateNewInstance,
                    ),
                    SizedBox(height: 24.0),
                    _RestoreBackupActionCard(
                      onRestore: onRestoreBackup,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _RestoreBackupActionCard extends StatelessWidget {
  final void Function() onRestore;

  const _RestoreBackupActionCard({
    Key? key,
    required this.onRestore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledActionCard(
      title: "Restore your diary",
      subtitle: "Continue your journey",
      actionButtonData: [
        ActionButtonData(
          title: "Restore diary",
          onPressed: onRestore,
          backgroundColor: Color(0xFFC7EBD3),
          accentColor: Color(0xFFD7ECF4),
        ),
      ],
    );
  }
}

class _CreateNewActionCard extends StatelessWidget {
  final void Function() onCreate;
  const _CreateNewActionCard({
    Key? key,
    required this.onCreate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledActionCard(
      title: "Create a new diary",
      subtitle: "Start a new journey",
      actionButtonData: [
        ActionButtonData(
          title: "Create new diary",
          onPressed: onCreate,
          backgroundColor: Color(0xFFEBC7CF),
          accentColor: Color(0xFFDFD7F4),
        ),
      ],
    );
  }
}
