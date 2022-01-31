part of widgets;

/// A Flutter widget allowing the user to confirm the creation of a new diary
/// while canceling the restoring of a backuped diary.
///
class CancelRestoringDialog extends StatelessWidget {
  /// Handles the `cancel` action.
  final void Function() onCancel;

  /// Creates a [CancelRestoringDialog].
  const CancelRestoringDialog({
    Key? key,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      child: LitDescriptionTextBox(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        text: AppLocalizations.of(context).cancelRestoreDescr,
      ),
      titleText: LeitmotifLocalizations.of(context).cancelLabel + "?",
      actionButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: LitPushedThroughButton(
            child: Text(
              AppLocalizations.of(context).createLabel.toUpperCase(),
              style: LitSansSerifStyles.button,
              textAlign: TextAlign.center,
            ),
            onPressed: onCancel,
          ),
        )
      ],
    );
  }
}
