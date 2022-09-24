part of widgets;

/// A dialog widgets allowing to confirm the deletion of all photos related to
/// a diary entry. The corresponding diary entry's photo list will be updated
/// using an empty list.
class DeleteAllPhotosDialog extends StatefulWidget {
  /// The diary entry, whose photos should be deleted.
  final DiaryEntry entry;

  /// Creates a [DeleteAllPhotosDialog].
  const DeleteAllPhotosDialog({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  State<DeleteAllPhotosDialog> createState() => _DeleteAllPhotosDialogState();
}

class _DeleteAllPhotosDialogState extends State<DeleteAllPhotosDialog> {
  /// The [AppAPI] instance.
  final AppAPI _api = AppAPI();

  /// Deletes the photos and closes the dialog.
  void _deletePhotos() {
    DiaryEntry updated = DiaryEntry(
      uid: widget.entry.uid,
      date: widget.entry.date,
      created: widget.entry.created,
      lastUpdated: widget.entry.lastUpdated,
      title: widget.entry.title,
      content: widget.entry.content,
      moodScore: widget.entry.moodScore,
      favorite: widget.entry.favorite,
      backdropPhotoId: widget.entry.backdropPhotoId,
      photos: DefaultData.photos,
      visitCount: widget.entry.visitCount,
      editCount: widget.entry.editCount,
    );
    // Update the diary entry to delete all photos.
    _api.updateDiaryEntry(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: AppLocalizations.of(context).noPhotosSelectedLabel,
      margin: LitEdgeInsets.dialogMargin,
      child: Column(
        children: [
          LitDescriptionTextBox(
            text: AppLocalizations.of(context).deletePhotosDescr,
          ),
          SizedBox(height: 4.0),
          Text(
            AppLocalizations.of(context).deletePhotosActionLabel,
            style: LitSansSerifStyles.subtitle2,
          ),
        ],
      ),
      actionButtons: [
        DialogActionButton(
          data: ActionButtonData(
            title: LeitmotifLocalizations.of(context).deleteLabel,
            backgroundColor: LitColors.red200,
            accentColor: LitColors.red200,
            onPressed: _deletePhotos,
          ),
        )
      ],
    );
  }
}
