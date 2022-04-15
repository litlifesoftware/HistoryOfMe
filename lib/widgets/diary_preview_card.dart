part of widgets;

/// A Flutter widget rendering a visual preview the provided [DiaryBackup] and
/// allowing the user to rebuild the database using the provided backup.
///
class DiaryPreviewCard extends StatefulWidget {
  /// The [BackupStorage] instance.
  final BackupStorage backupStorage;

  /// The preview data.
  final DiaryBackup diaryBackup;

  /// Handles the action to rebuild the database.
  final Future Function() rebuildDatabase;

  /// Handles the `select backup file` action.
  final void Function() selectBackup;

  /// Creates a [DiaryPreviewCard].
  const DiaryPreviewCard({
    Key? key,
    required this.diaryBackup,
    required this.rebuildDatabase,
    required this.selectBackup,
    required this.backupStorage,
  }) : super(key: key);

  @override
  State<DiaryPreviewCard> createState() => _DiaryPreviewCardState();
}

class _DiaryPreviewCardState extends State<DiaryPreviewCard> {
  /// The user icon's size displayed on the backup preview.
  final double _userIconSize = 48.0;

  /// The [Directory] the backup should be located at.
  late Directory storageDir;

  /// The path the images should be located at.
  String get imagesBackupPath =>
      widget.backupStorage.expectedBackupPath + '/' + 'images' + '/';

  /// Restores all user data.
  Future<void> restore() async {
    await widget.rebuildDatabase();

    if (!storageDir.existsSync()) {
      storageDir.createSync();
    }

    for (DiaryPhoto photo in _photos) {
      if (File(imagesBackupPath + photo.name).existsSync()) {
        try {
          await File(imagesBackupPath + photo.name).copy(photo.path);
        } catch (e) {
          print("Failed to restore image on " + imagesBackupPath + photo.name);
          print(e);
        }
      }
      print("Skipping DiaryPhoto on " + "'" + photo.path + "'");
    }
  }

  /// Returns a [List] of restorable file entities, that are linked on a diary
  /// entry and are also available on the device's file system.
  List<FileSystemEntity> get restorableImageFiles {
    List<FileSystemEntity> matches = [];

    for (DiaryPhoto photo in _photos) {
      for (FileSystemEntity entity in backedUpImageFiles) {
        List<String> entityparts = entity.path.split('/');
        String name = entityparts[entityparts.length - 1];
        print(photo.name + " / " + name);
        if (name == photo.name) {
          matches.add(entity);
        }
      }
    }
    return matches;
  }

  /// Returns a [List] of all available file entities that are previously
  /// backed up.
  List<FileSystemEntity> get backedUpImageFiles {
    List<FileSystemEntity> files = [];

    try {
      files = Directory(
        imagesBackupPath,
      ).listSync().toList();
    } catch (e) {
      print("There is no images Directory ...");
    }

    return files;
  }

  /// Returns whether all diary photos are restorable.
  bool get _photoBackupValid {
    return restorableImageFiles.length == _photos.length;
  }

  /// Returns a [List] of all [DiaryPhoto] items linked on user's diary entries.
  List<DiaryPhoto> get _photos {
    List<DiaryPhoto> photos = [];

    for (DiaryEntry entry in widget.diaryBackup.diaryEntries) {
      if (entry.photos != null) {
        for (DiaryPhoto photo in entry.photos!) {
          photos.add(photo);
          print(photo.path);
        }
      }
    }

    return photos;
  }

  /// Initiates the [storageDir] object.
  void _initPath() async {
    storageDir = await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
  }

  /// Shows the [PhotosMissingDialog].
  void _showMissingPhotosInfoDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return PhotosMissingDialog();
        });
  }

  @override
  void initState() {
    _initPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LitTitledActionCard(
      title: AppLocalizations.of(context).foundDiaryTitle,
      subtitle: AppLocalizations.of(context).continueJourneyTitle,
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
                      UserIcon(
                        size: _userIconSize,
                        userData: widget.diaryBackup.userData,
                      ),
                      SizedBox(
                        height: _userIconSize,
                        width: constraints.maxWidth - _userIconSize,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            top: 2.0,
                            bottom: 2.0,
                            right: 2.0,
                          ),
                          child: _BackupPreviewTitle(
                            diaryBackup: widget.diaryBackup,
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
                userData: widget.diaryBackup.userData,
              ),
              SizedBox(
                height: 16.0,
              ),
              _MetaDataPreview(
                diaryBackup: widget.diaryBackup,
                photos: _photos,
                matches: restorableImageFiles,
                isValid: _photoBackupValid,
                showMissingPhotosDialog: _showMissingPhotosInfoDialog,
              ),
            ],
          );
        },
      ),
      actionButtonData: [
        ActionButtonData(
          title: LeitmotifLocalizations.of(context).restoreLabel.toUpperCase(),
          onPressed: restore,
          backgroundColor: AppColors.pastelGreen,
          accentColor: AppColors.pastelBlue,
        ),
        ActionButtonData(
          title: AppLocalizations.of(context).selectAnother,
          onPressed: widget.selectBackup,
          backgroundColor: AppColors.pastelPink,
          accentColor: AppColors.pastelPink,
        ),
      ],
    );
  }
}

/// A Flutter widget displaying the backup preview's title.
class _BackupPreviewTitle extends StatelessWidget {
  final DiaryBackup diaryBackup;
  const _BackupPreviewTitle({
    Key? key,
    required this.diaryBackup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClippedText(
          AppLocalizations.of(context).diaryOfLabel +
              " " +
              diaryBackup.userData.name,
          style: LitSansSerifStyles.subtitle2,
        ),
        RichText(
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: App.appName,
                style: LitSansSerifStyles.caption,
              ),
              TextSpan(
                text: " " + diaryBackup.appVersion,
                style: LitSansSerifStyles.caption.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A Flutter widget displaying the [DiaryBackup]'s meta data.
class _MetaDataPreview extends StatelessWidget {
  final bool isValid;
  final DiaryBackup diaryBackup;
  final List<DiaryPhoto> photos;
  final List<FileSystemEntity> matches;
  final void Function() showMissingPhotosDialog;

  /// Creates a [_MetaDataPreview].
  const _MetaDataPreview({
    Key? key,
    required this.isValid,
    required this.diaryBackup,
    required this.photos,
    required this.matches,
    required this.showMissingPhotosDialog,
  }) : super(key: key);

  static const double _labelWidth = 128.0;

  double calcPhotoWidth(BoxConstraints constraints) =>
      constraints.maxWidth / (photos.length > 1 ? 2 : 1);

  double calcContainerWidth(BoxConstraints constraints) =>
      constraints.maxWidth - _labelWidth - 4.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: _labelWidth,
                  child: Text(
                    AppLocalizations.of(context).lastEditedLabel,
                    style: LitSansSerifStyles.body2,
                  ),
                ),
                SizedBox(
                  width: 4.0,
                ),
                SizedBox(
                  width: calcContainerWidth(constraints),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClippedText(
                        DateTime.parse(diaryBackup.backupDate)
                            .formatAsLocalizedDate(context),
                        style: LitSansSerifStyles.subtitle1,
                      ),
                      RelativeDateTimeBuilder.now(
                        date: DateTime.parse(diaryBackup.backupDate),
                        builder: (date, formatted) {
                          return ClippedText(
                            formatted,
                            style: LitSansSerifStyles.caption,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: _labelWidth,
                  child: Text(
                    AppLocalizations.of(context).entriesLabel.capitalize(),
                    style: LitSansSerifStyles.body2,
                  ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: _labelWidth,
                  child: Text(
                    AppLocalizations.of(context).photosTotalLabel,
                    style: LitSansSerifStyles.body2,
                  ),
                ),
                LitBadge(
                  borderRadius: BorderRadius.circular(16.0),
                  backgroundColor: LitColors.lightGrey,
                  child: Text(
                    photos.length.toString(),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: _labelWidth,
                  child: Text(
                    AppLocalizations.of(context).photosFoundLabel,
                    style: LitSansSerifStyles.body2,
                  ),
                ),
                LitBadge(
                  borderRadius: BorderRadius.circular(16.0),
                  backgroundColor: LitColors.lightGrey,
                  child: Text(
                    matches.length.toString(),
                    style: LitSansSerifStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            matches.length != 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Container(
                      height: 64.0,
                      width: constraints.maxWidth,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: matches.length,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () => {
                              showDialog(
                                context: context,
                                builder: (context) => ImagePreviewDialog(
                                  path: matches[index].path,
                                ),
                              )
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Container(
                                  height: 64.0,
                                  width: calcPhotoWidth(constraints),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.file(
                                      File(
                                        matches[index].path,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    isValid
                        ? AppLocalizations.of(context).allPhotosRestorableLabel
                        : AppLocalizations.of(context).somePhotosMissingLabel,
                    style: LitSansSerifStyles.caption,
                  ),
                  isValid
                      ? SizedBox()
                      : _MissingPhotosIconButton(
                          onTap: showMissingPhotosDialog,
                        ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
          ],
        );
      },
    );
  }
}

/// An button widget calling the provided [onTap] callback when being pressed.
class _MissingPhotosIconButton extends StatelessWidget {
  final void Function() onTap;

  /// Creates a [_MissingPhotosIconButton].
  const _MissingPhotosIconButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  Color get _color => LitColors.grey200;

  BorderRadius get _borderRadius => const BorderRadius.all(
        Radius.circular(
          10.0,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: LitPushedThroughButton(
          boxShadow: LitBoxShadows.sm,
          accentColor: _color,
          backgroundColor: _color,
          borderRadius: _borderRadius,
          margin: const EdgeInsets.all(8.0),
          child: Icon(
            LitIcons.info,
            color: LitColors.grey400,
            size: 12.0,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}
