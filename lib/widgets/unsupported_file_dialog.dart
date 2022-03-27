part of widgets;

/// A dialog widget showing a information message that the desired file is not
/// supported by this app.
class UnsupportedFileDialog extends StatefulWidget {
  /// Creates a [UnsupportedFileDialog].
  const UnsupportedFileDialog({Key? key}) : super(key: key);

  @override
  State<UnsupportedFileDialog> createState() => _UnsupportedFileDialogState();
}

class _UnsupportedFileDialogState extends State<UnsupportedFileDialog> {
  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: LeitmotifLocalizations.of(context).unsupportedFileTitle,
      margin: LitEdgeInsets.none,
      child: CleanInkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: LitEdgeInsets.dialogMargin,
          child: LitDescriptionTextBox(
            text: LeitmotifLocalizations.of(context).unsupportedFileDescr,
          ),
        ),
      ),
    );
  }
}
