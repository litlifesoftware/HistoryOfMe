part of widgets;

/// A dialog widgets shown in case some photos cannot be restored from the
/// backup directory.
class PhotosMissingDialog extends StatelessWidget {
  /// Creates a [PhotosMissingDialog].
  const PhotosMissingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: AppLocalizations.of(context).photosMissingLabel,
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      minHeight: 128.0,
      child: LitDescriptionTextBox(
        maxLines: 6,
        text: AppLocalizations.of(context).photosMissingDescr,
      ),
    );
  }
}
