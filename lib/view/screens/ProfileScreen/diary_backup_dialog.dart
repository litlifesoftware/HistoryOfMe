import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:history_of_me/model/diary_backup.dart';
import 'package:history_of_me/model/models.dart';
import 'package:history_of_me/view/provider/providers.dart';
import 'package:leitmotif/leitmotif.dart';
import 'package:leitmotif/dialogs.dart';
import 'package:lit_backup_service/lit_backup_service.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DiaryBackupDialog extends StatefulWidget {
  const DiaryBackupDialog({Key? key}) : super(key: key);

  @override
  _DiaryBackupDialogState createState() => _DiaryBackupDialogState();
}

class _DiaryBackupDialogState extends State<DiaryBackupDialog> {
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

  Future<void> _writeBackup(DiaryBackup backup) async {
    setState(
      () => {
        backupStorage.writeBackup(backup),
      },
    );
  }

  Future<void> _deleteBackup() async {
    setState(
      () => {
        backupStorage.deleteBackup(),
      },
    );
  }

  DiaryBackup _createBackup(
    AppSettings appSettings,
    List<DiaryEntry> diaryEntries,
    List<UserCreatedColor> userCreatedColors,
    UserData userData,
  ) {
    return DiaryBackup(
      appSettings: appSettings,
      diaryEntries: diaryEntries,
      userCreatedColors: userCreatedColors,
      userData: userData,
      appVersion: _packageInfo!.version,
      backupDate: DateTime.now().toIso8601String(),
    );
  }

  Future<BackupModel?> _readBackup() {
    return backupStorage.readBackup(
      decode: (contents) => DiaryBackup.fromJson(
        jsonDecode(contents),
      ),
    );
  }

  @override
  void initState() {
    _initPackageInfo();
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
                          _createBackup(
                            appSettings,
                            diaryEntries,
                            userCreatedColors,
                            userData,
                          ),
                        ),
                      )
                    : Text("Unsupported Backup!");
              }

              if (snap.hasError) return Text("Could load fetch diary backup!");
            } else if (snap.connectionState == ConnectionState.waiting) {
              return _LoadingBackupDialog();
            }
            return _CreateBackupDialog(
              writeBackup: () => _writeBackup(
                _createBackup(
                  appSettings,
                  diaryEntries,
                  userCreatedColors,
                  userData,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _LoadingBackupDialog extends StatelessWidget {
  const _LoadingBackupDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: "Loading Backup",
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

class _CreateBackupDialog extends StatelessWidget {
  final void Function() writeBackup;

  const _CreateBackupDialog({
    Key? key,
    required this.writeBackup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: "No Backup found",
      actionButtons: [
        DialogActionButton(
          label: "BACKUP NOW",
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
              "We did not find any backups.",
              style: LitSansSerifStyles.body2,
            ),
          ),
          _InfoDescription(),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
            ),
            child: Text(
              "Consider to backup your diary to prevent possible data loss.",
              style: LitSansSerifStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}

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
          label: "DELETE",
          onPressed: deleteBackup,
          backgroundColor: LitColors.lightPink,
          accentColor: Colors.white,
        ),
        DialogActionButton(
          label: "BACKUP",
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
      titleText: "Backup your diary",
    );
  }
}

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
  RelativeDateTime get _relBackupDate {
    return RelativeDateTime(
      dateTime: DateTime.now(),
      other: DateTime.parse(widget.diaryBackup.backupDate),
    );
  }

  RelativeDateFormat get _relBackupDateFormatter {
    return RelativeDateFormat(
      Localizations.localeOf(context),
    );
  }

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
        _MetaDataText(
          keyText: "Total entries:",
          valueText: widget.diaryBackup.diaryEntries.length.toString(),
        ),
        _MetaDataText(
          keyText: "Last Backup:",
          valueText: DateTime.parse(widget.diaryBackup.backupDate)
              .formatAsLocalizedDate(context),
          description: _relBackupDateFormatter.format(
            _relBackupDate,
          ),
        ),
        _UpToDateIndicator(
          diaryBackup: widget.diaryBackup,
        )
      ],
    );
  }
}

class _InfoDescription extends StatelessWidget {
  const _InfoDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50.0,
              child: Center(
                child: Container(
                  height: 42.0,
                  width: 42.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: LitBoxShadows.sm,
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      LitIcons.info,
                      size: 13.0,
                      color: Color(0xFF616161),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 50.0,
              width: constraints.maxWidth - 42.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Center(
                  child: ClippedText(
                    "Backups help you to restore your diary after you deleted this app or if you loose your phone.",
                    maxLines: 3,
                    style: LitSansSerifStyles.caption,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

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
    int daysSinceBackup = DateTime.now()
        .difference(
          DateTime.parse(widget.diaryBackup.backupDate),
        )
        .inDays;

    return daysSinceBackup < 2;
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
                "Up to date:",
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
                    "Your diary is up-to-date!",
                    style: LitSansSerifStyles.caption,
                  )
                : Text(
                    "Your diary is older than two days. We recommend to backup your diary regularly to prevent data loss.",
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

class _MetaDataText extends StatelessWidget {
  final String keyText;
  final String valueText;
  final String? description;
  const _MetaDataText({
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
              Text(
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
              Text(
                valueText,
                style: LitSansSerifStyles.body2,
              ),
              description != null
                  ? Text(
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
