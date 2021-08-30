import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:history_of_me/model/diary_backup.dart';
import 'package:leitmotif/leitmotif.dart';
import 'package:leitmotif/scaffold.dart';
import 'package:leitmotif/styles.dart';
import 'package:lit_backup_service/controller/controllers.dart';
import 'package:lit_backup_service/lit_backup_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  late LitRouteController _routeController;

  @override
  void initState() {
    _routeController = LitRouteController(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _SelectCreateModeScreen();
  }
}

class _SelectBackupScreen extends StatefulWidget {
  const _SelectBackupScreen({Key? key}) : super(key: key);

  @override
  __SelectBackupScreenState createState() => __SelectBackupScreenState();
}

class __SelectBackupScreenState extends State<_SelectBackupScreen> {
  final BackupStorage backupStorage = BackupStorage(
    organizationName: "LitLifeSoftware",
    applicationName: "HistoryOfMe",
    fileName: "historyofmebackup",
  );

  Future<BackupModel?> _readBackup() {
    return backupStorage.readBackup(
      decode: (contents) => DiaryBackup.fromJson(
        jsonDecode(contents),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    backupStorage.requestPermissions().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return LitScaffold(
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
                    future: _readBackup(),
                    builder: (context, AsyncSnapshot<BackupModel?> snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        if (snap.hasData) {
                          DiaryBackup? diaryBackup = snap.data as DiaryBackup;

                          return snap.data != null
                              ? LitTitledActionCard(
                                  title: "We found your diary",
                                  subtitle: "Continue your journey",
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Column(
                                        children: [
                                          SizedBox(height: 16.0),
                                          Text(diaryBackup.userData.name)
                                          // Row(
                                          //   children: [
                                          //     SizedBox(
                                          //       height: 32.0,
                                          //       width: constraints.maxWidth / 2,
                                          //       child: Padding(
                                          //         padding: const EdgeInsets.only(
                                          //           right: 8.0,
                                          //         ),
                                          //         child: LitPushedThroughButton(
                                          //           onPressed: () {},
                                          //           child: ClippedText(
                                          //             "Select".toUpperCase(),
                                          //             style: LitSansSerifStyles.button,
                                          //             textAlign: TextAlign.center,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     SizedBox(
                                          //       height: 32.0,
                                          //       width: constraints.maxWidth / 2,
                                          //       child: Padding(
                                          //         padding: const EdgeInsets.only(
                                          //           left: 8.0,
                                          //         ),
                                          //         child: Container(
                                          //           decoration: BoxDecoration(
                                          //             color: Colors.white,
                                          //             boxShadow: LitBoxShadows.sm,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : Text("Unsupported Backup!");
                        }

                        if (snap.hasError)
                          return Text("Could load fetch diary backup!");
                      } else if (snap.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      // Either backup not found or missing
                      // permissions on device.
                      return FutureBuilder(
                        future: backupStorage.hasPermissions(),
                        builder: (context, AsyncSnapshot<bool> hasPerSnap) {
                          return hasPerSnap.hasData
                              ? !hasPerSnap.data!
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Reading backup from storage denied.",
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
                                                backgroundColor:
                                                    Color(0xFFC7EBD3),
                                                accentColor: Color(0xFFD7ECF4),
                                                child: Text(
                                                  "Request permissions"
                                                      .toUpperCase(),
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      LitSansSerifStyles.button,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    )
                                  : Text(
                                      "Backup not found!",
                                    )
                              : SizedBox();
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24.0),
                  _CreateNewActionCard(onCreate: () {})
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SelectCreateModeScreen extends StatelessWidget {
  const _SelectCreateModeScreen({Key? key}) : super(key: key);

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
                      onCreate: () {},
                    ),
                    SizedBox(height: 24.0),
                    _RestoreBackupActionCard(
                      onRestore: () {},
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

class RestoreScreen extends StatefulWidget {
  const RestoreScreen({Key? key}) : super(key: key);

  @override
  _RestoreScreenState createState() => _RestoreScreenState();
}

class _RestoreScreenState extends State<RestoreScreen> {
  final BackupStorage backupStorage = BackupStorage(
    organizationName: "LitLifeSoftware",
    applicationName: "HistoryOfMe",
    fileName: "historyofmebackup",
  );

  PackageInfo? _packageInfo;

  Future<void> _initPackageInfo() async {
    var info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<BackupModel?> _readBackup() {
    return backupStorage.readBackup(
      decode: (contents) => DiaryBackup.fromJson(
        jsonDecode(contents),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    backupStorage.requestPermissions().then(
          (value) => _refresh(),
        );
  }

  void _refresh() {
    setState(() {});
  }

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40.0,
            ),
            child: _packageInfo != null
                ? FutureBuilder(
                    future: _readBackup(),
                    builder: (context, AsyncSnapshot<BackupModel?> snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        if (snap.hasData) {
                          DiaryBackup? diaryBackup = snap.data as DiaryBackup;

                          return snap.data != null
                              ? Text(
                                  "Backup found of ${diaryBackup.userData.name}",
                                )
                              : Text(
                                  "Unsupported Backup!",
                                );
                        }

                        if (snap.hasError) return Text("error");
                      } else if (snap.connectionState ==
                          ConnectionState.waiting) {
                        return Material(
                          child: SizedBox(
                            height: 64.0,
                            width: 64.0,
                            child: JugglingLoadingIndicator(
                              indicatorColor: Colors.black,
                              backgroundColor: Colors.white,
                              shadowOpacity: 0.25,
                            ),
                          ),
                        );
                      }
                      // Permission denied or no backup availble.

                      return FutureBuilder(
                        future: backupStorage.hasPermissions(),
                        builder: (context, AsyncSnapshot<bool> hasPerSnap) {
                          return hasPerSnap.hasData
                              ? !hasPerSnap.data!
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            "Reading backup from storage denied.",
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: _requestPermissions,
                                          child: Text(
                                            "Request Permissions",
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Text(
                                          "Backup not found!",
                                        ),
                                        ElevatedButton(
                                          onPressed: _refresh,
                                          child: Icon(
                                            Icons.refresh,
                                          ),
                                        )
                                      ],
                                    )
                              : SizedBox();
                        },
                      );
                    },
                  )
                : SizedBox(),
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
