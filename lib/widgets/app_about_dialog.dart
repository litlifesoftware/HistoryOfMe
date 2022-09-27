part of widgets;

/// A customized [LitAboutDialog] widget displaying the app's about dialog.
class AppAboutDialog extends StatelessWidget {
  /// Creates a [AppAboutDialog].
  const AppAboutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitAboutDialog(
      title: LeitmotifLocalizations.of(context).aboutAppLabel,
      appName: App.appName,
      art: HistoryOfMeLauncherIconArt(
        boxShadow: LitBoxShadows.sm,
      ),
      infoDescription: AppLocalizations.of(context).aboutAppDescr,
    );
  }
}
