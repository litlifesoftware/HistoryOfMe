part of widgets;

/// A Flutter widget rendering a visual preview the provided [DiaryBackup] and
/// allowing the user to rebuild the database using the provided backup.
///
class DiaryPreviewCard extends StatelessWidget {
  /// The preview data.
  final DiaryBackup diaryBackup;

  /// Handles the action to rebuild the database.
  final Future Function() rebuildDatabase;

  /// Handles the `select backup file` action.
  final void Function() selectBackup;

  /// The user icon's size displayed on the backup preview.
  final double _userIconSize = 48.0;

  /// Creates a [DiaryPreviewCard].
  const DiaryPreviewCard({
    Key? key,
    required this.diaryBackup,
    required this.rebuildDatabase,
    required this.selectBackup,
  }) : super(key: key);

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
                        userData: diaryBackup.userData,
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
                            diaryBackup: diaryBackup,
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
              _MetaDataPreview(
                diaryBackup: diaryBackup,
              ),
            ],
          );
        },
      ),
      actionButtonData: [
        ActionButtonData(
          title: LeitmotifLocalizations.of(context).restoreLabel.toUpperCase(),
          onPressed: rebuildDatabase,
          backgroundColor: AppColors.pastelGreen,
          accentColor: AppColors.pastelBlue,
        ),
        ActionButtonData(
          title: AppLocalizations.of(context).selectAnother,
          onPressed: selectBackup,
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
  final DiaryBackup diaryBackup;
  final double _labelWidth = 128.0;
  const _MetaDataPreview({
    Key? key,
    required this.diaryBackup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
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
                  width: constraints.maxWidth - _labelWidth - 4.0,
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
          ],
        );
      },
    );
  }
}
