part of widgets;

/// A Flutter dialog widget allowing the user to create and manage backup files.
///
/// Each backup file is named differently depending on the timestamp of the
/// last app installation.
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
  final AppAPI _api = AppAPI();
  late BackupStorage _backupStorage;
  late PackageInfo _packageInfo;
  late Directory storageDir;
  late Directory imagesCacheDirectory;

  bool includePhotos = true;
  int photosCopied = 0;
  int duplicatesDeleted = 0;
  bool isProcessing = false;

  void setIncludePhotos(bool val) {
    includePhotos = val;
  }

  /// Initializes the [_backupStorage].
  void _initBackupStorage() {
    _backupStorage = BackupStorage(
      organizationName: "LitLifeSoftware",
      applicationName: "HistoryOfMe",
      fileName: "historyofmebackup",
      installationID: widget.installationID,
      useShortDirectoryNaming: true,
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

    setState(() => isProcessing = true);

    await _backupStorage.writeBackup(backup);
    await _backupPhotos(backup);

    _api.updateLastBackup(appSettings, now);

    setState(() => isProcessing = false);
  }

  String get imagesBackupDirectoryPath =>
      _backupStorage.expectedBackupPath + '/' + 'images';
  String get imagesBackupPath =>
      _backupStorage.expectedBackupPath + '/' + 'images' + '/';

  Future<void> _deleteUnusedStorageFiles(
      DiaryBackup backup, int counter, void Function(int) setCounter) async {
    List<DiaryPhoto> photos = [];

    for (DiaryEntry e in backup.diaryEntries) {
      if (e.photos != null) {
        photos.addAll(e.photos!);
      }
    }

    for (FileSystemEntity fse in storageDir.listSync()) {
      if (fse is File) {
        if (!diaryPhotoExistsByPath(photos, fse)) {
          try {
            await File(fse.path).delete();

            setCounter(counter++);

            DebugOutputService.printStorageImageFileDeleted(fse.path);
          } catch (e) {
            DebugOutputService.printStorageImageFileDeletionError(fse.path);
          }
        }
      }
    }
  }

  Future<void> _deleteUnusedBackupFiles(
      DiaryBackup backup, int counter, void Function(int) setCounter) async {
    List<DiaryPhoto> photos = [];
    //int counter = 0;

    Directory backupDirectory = Directory(imagesBackupDirectoryPath);

    for (DiaryEntry e in backup.diaryEntries) {
      if (e.photos != null) {
        photos.addAll(e.photos!);
      }
    }

    for (FileSystemEntity f in backupDirectory.listSync()) {
      if (f is File) {
        if (!diaryPhotoExistsByName(photos, f)) {
          try {
            await File(f.path).delete();
            //counter++;
            setCounter(counter++);

            DebugOutputService.printBackedUpImageFileDeleted(f.path);
          } catch (e) {
            DebugOutputService.printBackedUpImageFileDeletionError(f.path);
          }
        }
      }
    }
  }

  /// Returns whether the provided image file is linked to any [DiaryPhoto]
  /// based on the file's path.
  bool diaryPhotoExistsByPath(List<DiaryPhoto> photos, File f) {
    for (DiaryPhoto p in photos) {
      if (p.path == f.path) {
        //print("File: " + fse.path + " is linked to a DiaryEntry");
        DebugOutputService.printImageFileLinked(f.path);
        return true;
      }
    }
    return false;
  }

  /// Returns whether the provided image file is linked to any [DiaryPhoto]
  /// based on the file's name.
  bool diaryPhotoExistsByName(List<DiaryPhoto> photos, File f) {
    for (DiaryPhoto p in photos) {
      if (p.name == f.name) {
        //print("File: " + f.path + " is linked to a DiaryEntry");
        DebugOutputService.printImageFileLinked(f.path);
        return true;
      }
    }
    return false;
  }

  Future<void> _backupPhotos(DiaryBackup backup) async {
    setState(() {
      photosCopied = 0;
      duplicatesDeleted = 0;
    });

    int storageDuplicateCounter = 0;
    int backupDuplicateCounter = 0;

    if (includePhotos) {
      // Creates the images backup directory (if it doesn't exists yet).
      Directory(imagesBackupDirectoryPath).create();

      for (DiaryEntry entry in backup.diaryEntries) {
        if (entry.photos != null) {
          for (DiaryPhoto photo in entry.photos!) {
            String filePath = imagesBackupPath + photo.name;

            bool exists = await File(filePath).exists();

            if (!exists) {
              bool existsOnStorage = await File(photo.path).exists();
              if (existsOnStorage) {
                await File(photo.path)
                    .copy(
                      filePath,
                    )
                    .then(
                      (__) => photosCopied++,
                    )
                    .then((____) {
                  DebugOutputService.printImageFileCopied(filePath);
                });
              } else {
                DebugOutputService.printImageFileStorageError(photo.path);
              }
            } else {
              DebugOutputService.printBackedUpImageFileDuplicateError(filePath);
            }
          }
        }
      }
    }

    // Delete all unused files on the application's storage directory.
    await _deleteUnusedStorageFiles(
      backup,
      storageDuplicateCounter,
      (int v) {
        storageDuplicateCounter = v;
      },
    );

    // Delete all unused files on the application's backup directory.
    await _deleteUnusedBackupFiles(
      backup,
      backupDuplicateCounter,
      (int v) {
        backupDuplicateCounter = v;
      },
    );

    setState(() =>
        duplicatesDeleted = storageDuplicateCounter + backupDuplicateCounter);
  }

  /// Deletes the currently maintained backup file including the backed up
  /// images.
  Future<void> _deleteBackup() async {
    setState(() => isProcessing = false);
    await _backupStorage.deleteBackup();
    // If there are backed up images
    if (await Directory(imagesBackupPath).exists()) {
      // Delete the backup images
      //await Directory(imagesBackupPath).delete(recursive: true);
      await Directory(imagesBackupPath).list().toList().then(
            (v) => v.forEach((file) async {
              try {
                await file.delete();
                print("File on " + "'" + file.path + "'" + " " + "deleted");
              } catch (e) {
                print("File not found ...");
              }
            }),
          );
    }
    setState(() => isProcessing = false);
  }

  /// Returns a [DiaryBackup] (backup file content) using cleaned data objects.
  ///
  /// Cleaning the individual objects before creating the backup object is
  /// required to ensure older data sets are updated to the according
  /// standards. Otherwise the serialization will fail, resulting in invalid
  /// backup files and typecast errors when reading backup files.
  DiaryBackup _getCleanBackup(
    AppSettings appSettings,
    List<DiaryEntry> diaryEntries,
    List<UserCreatedColor> userCreatedColors,
    UserData userData,
  ) {
    List<DiaryEntry> cleanDiaryEntries = [];

    /// The initial tap index will lead to the `ProfileScreen` to avoid the
    /// `HomeScreen` being rendered incorrectly on first startup after
    /// restoring the diary.
    final cleanSettings = AppSettings(
      privacyPolicyAgreed: appSettings.privacyPolicyAgreed,
      darkMode: appSettings.privacyPolicyAgreed,
      tabIndex: 0,
      installationID: appSettings.installationID,
      lastBackup: "",
    );

    // Add the provided diary entries to the cleaned list.
    for (DiaryEntry item in diaryEntries) {
      cleanDiaryEntries.add(
        DiaryEntry(
          uid: item.uid,
          date: item.date,
          created: item.created,
          lastUpdated: item.lastUpdated,
          title: item.title,
          content: item.content,
          moodScore: item.moodScore,
          favorite: item.favorite,
          backdropPhotoId: item.backdropPhotoId,
          photos: item.photos ?? [],
        ),
      );
    }

    return DiaryBackup(
      appSettings: cleanSettings,
      diaryEntries: cleanDiaryEntries,
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

  void _initDirectories() async {
    storageDir = await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    imagesCacheDirectory = await getTemporaryDirectory();
  }

  @override
  void initState() {
    _initPackageInfo();
    _initBackupStorage();
    _initDirectories();
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
                            userData!,
                          ),
                          appSettings,
                        ),
                        includePhotos: includePhotos,
                        setIncludePhotos: setIncludePhotos,
                        photosCopied: photosCopied,
                        duplicatesDeleted: duplicatesDeleted,
                        imagesBackupPath: imagesBackupPath,
                        isProcessing: isProcessing,
                      )
                    : Text("Unsupported Backup!");
              }

              if (snap.hasError) return Text("Could load fetch diary backup!");
            } else if (snap.connectionState == ConnectionState.waiting ||
                snap.connectionState == ConnectionState.none) {
              return _LoadingBackupDialog();
            }

            return FutureBuilder(
              future: _backupStorage.hasPermissions(),
              builder: (context, AsyncSnapshot<bool> hasPerSnap) {
                if (hasPerSnap.connectionState == ConnectionState.done) {
                  if (hasPerSnap.hasData) {
                    if (hasPerSnap.data == null)
                      return Text("Unsupported Permission Configuration!" +
                          " " +
                          "Please check the app's compatibility with" +
                          " " +
                          "your device.");

                    if (hasPerSnap.data!)
                      return _CreateBackupDialog(
                        writeBackup: () => _writeBackup(
                          _getCleanBackup(
                            appSettings,
                            diaryEntries,
                            userCreatedColors,
                            userData!,
                          ),
                          appSettings,
                        ),
                        includePhotos: includePhotos,
                        setIncludePhotos: setIncludePhotos,
                      );

                    if (!hasPerSnap.data!)
                      return _PermissionDeniedDialog(
                        onGrant: _requestPermissions,
                      );

                    if (hasPerSnap.hasError)
                      return Text("Could not fetch Permission data!");
                  }
                  if (hasPerSnap.connectionState == ConnectionState.waiting ||
                      hasPerSnap.connectionState == ConnectionState.none) {
                    return _LoadingBackupDialog();
                  }
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
      titleText: AppLocalizations.of(context).readingLabel.capitalize(),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 192.0),
          child: JugglingLoadingIndicator(),
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
      titleText: AppLocalizations.of(context).storagePermissionDeniedTitle,
      actionButtons: [
        DialogActionButton(
          data: ActionButtonData(
            title: AppLocalizations.of(context).requestPermissionLabel,
            onPressed: onGrant,
          ),
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
              AppLocalizations.of(context).permissionsRequiredDescr,
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
  final void Function(bool) setIncludePhotos;
  final bool includePhotos;
  const _CreateBackupDialog({
    Key? key,
    required this.writeBackup,
    required this.setIncludePhotos,
    required this.includePhotos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: AppLocalizations.of(context).noBackupFoundTitle.capitalize(),
      actionButtons: [
        DialogActionButton(
          data: ActionButtonData(
            title: AppLocalizations.of(context).backupLabel.toUpperCase(),
            onPressed: writeBackup,
          ),
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
          _IncludePhotosToggleButton(
            value: includePhotos,
            setIncludePhotos: setIncludePhotos,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              AppLocalizations.of(context).noBackupFoundDescr,
              style: LitSansSerifStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}

class _IncludePhotosToggleButton extends StatelessWidget {
  final bool value;
  final void Function(bool) setIncludePhotos;
  const _IncludePhotosToggleButton({
    Key? key,
    required this.value,
    required this.setIncludePhotos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: constraints.maxWidth / 2),
                  child: Text(
                    AppLocalizations.of(context).includePhotosLabel,
                    style: LitSansSerifStyles.subtitle2,
                  ),
                ),
                LitToggleButton(
                  onChanged: setIncludePhotos,
                  value: value,
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Text(
              AppLocalizations.of(context).includePhotosDescr,
              style: LitSansSerifStyles.overline,
            ),
          ],
        );
      },
    );
  }
}

/// A dialog widget allowing the user to manage an existing backup.
class _ManageBackupDialog extends StatelessWidget {
  final DiaryBackup diaryBackup;
  final void Function() deleteBackup;
  final void Function() writeBackup;
  final bool includePhotos;
  final Function(bool) setIncludePhotos;
  final int photosCopied;
  final int duplicatesDeleted;
  final String imagesBackupPath;
  final bool isProcessing;
  const _ManageBackupDialog({
    Key? key,
    required this.diaryBackup,
    required this.deleteBackup,
    required this.writeBackup,
    required this.includePhotos,
    required this.setIncludePhotos,
    required this.photosCopied,
    required this.duplicatesDeleted,
    required this.imagesBackupPath,
    required this.isProcessing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      actionButtons: [
        DialogActionButton(
          data: ActionButtonData(
            title: LeitmotifLocalizations.of(context).deleteLabel,
            onPressed: deleteBackup,
            backgroundColor: LitColors.lightPink,
            accentColor: Colors.white,
          ),
        ),
        DialogActionButton(
          data: ActionButtonData(
            title: AppLocalizations.of(context).backupLabel,
            onPressed: writeBackup,
          ),
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
          return ScrollableColumn(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            constrained: false,
            children: isProcessing
                ? [
                    Center(
                      child: JugglingLoadingIndicator(),
                    ),
                  ]
                : [
                    _InfoDescription(),
                    SizedBox(height: 8.0),
                    _IncludePhotosToggleButton(
                      value: includePhotos,
                      setIncludePhotos: setIncludePhotos,
                    ),
                    SizedBox(height: 4.0),
                    _BackupPreview(
                      diaryBackup: diaryBackup,
                    ),
                    _UpToDateIndicator(
                      diaryBackup: diaryBackup,
                    ),
                    duplicatesDeleted != 0
                        ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: duplicatesDeleted.toString(),
                                  style: LitSansSerifStyles.body2,
                                ),
                                TextSpan(
                                  text: " " +
                                      (duplicatesDeleted == 1
                                          ? AppLocalizations.of(context)
                                              .duplicatePhotoRemovedLabel
                                          : AppLocalizations.of(context)
                                              .duplicatePhotosRemovedLabel) +
                                      ".",
                                  style: LitSansSerifStyles.body2,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    photosCopied != 0
                        ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: photosCopied.toString(),
                                  style: LitSansSerifStyles.body2,
                                ),
                                TextSpan(
                                  text: " " +
                                      (photosCopied == 1
                                          ? AppLocalizations.of(context)
                                              .photoCopiedLabel
                                          : AppLocalizations.of(context)
                                              .photosCopiedLabel) +
                                      ".",
                                  style: LitSansSerifStyles.body2,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
          );
        },
      ),
      titleText:
          LeitmotifLocalizations.of(context).manageBackupLabel.capitalize(),
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
  List<DiaryPhoto> get _photos {
    List<DiaryPhoto> list = [];

    for (DiaryEntry entry in widget.diaryBackup.diaryEntries) {
      if (entry.photos != null) {
        for (DiaryPhoto photo in entry.photos!) {
          list.add(photo);
        }
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _MetaDataItem(
          keyText: AppLocalizations.of(context).backupIdLabel,
          valueText: widget.diaryBackup.appSettings.installationID.toString(),
        ),
        _MetaDataItem(
          keyText: AppLocalizations.of(context).entriesLabel.capitalize(),
          valueText: widget.diaryBackup.diaryEntries.length.toString(),
        ),
        _MetaDataItem(
          keyText: AppLocalizations.of(context).photosLabel,
          valueText: _photos.length.toString(),
        ),
        _MetaDataItem(
          keyText: AppLocalizations.of(context).lastestBackupLabel,
          valueText: DateTime.parse(widget.diaryBackup.backupDate)
              .formatAsLocalizedDate(context),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedRelativeDateTimeBuilder(
            animateOpacity: true,
            date: DateTime.parse(widget.diaryBackup.backupDate),
            builder: (relDate, formatted) {
              return ClippedText(
                formatted,
                style: LitSansSerifStyles.caption,
              );
            },
          ),
        ),
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
      maxLines: 4,
      text: AppLocalizations.of(context).backupInfoDescr,
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth - 32.0 - 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      LeitmotifLocalizations.of(context).upToDateLabel,
                      style: LitSansSerifStyles.subtitle2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: _isUpToDate
                          ? Text(
                              AppLocalizations.of(context).upToDateDescr,
                              style: LitSansSerifStyles.caption,
                            )
                          : Text(
                              AppLocalizations.of(context)
                                  .deprecatedBackupDescr,
                              style: LitSansSerifStyles.caption.copyWith(
                                color: LitColors.darkRed,
                              ),
                            ),
                    ),
                  ],
                ),
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
          );
        },
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (constraints.maxWidth / 2) - 2.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClippedText(
                      keyText,
                      style: LitSansSerifStyles.subtitle2,
                    ),
                    description != null ? Text("") : SizedBox()
                  ],
                ),
              ),
              SizedBox(width: 4.0),
              SizedBox(
                width: (constraints.maxWidth / 2) - 2.0,
                child: Column(
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
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
