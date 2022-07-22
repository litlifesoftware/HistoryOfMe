part of widgets;

/// A footer widget allowing to navigate various secondary screens and dialogs
/// to e.g. manage certain settings.
class SettingsFooter extends StatefulWidget {
  /// The latest [AppSettings] object.
  final AppSettings appSettings;

  /// The latest [UserData] object.
  final UserData? userData;

  /// Creates a [SettingsFooter].
  const SettingsFooter({
    Key? key,
    required this.appSettings,
    required this.userData,
  }) : super(key: key);
  @override
  _SettingsFooterState createState() => _SettingsFooterState();
}

class _SettingsFooterState extends State<SettingsFooter> {
  /// Shows the about dialog.
  void _showAboutThisAppDialog() {
    LitRouteController(context).showDialogWidget(_AboutDialog());
  }

  /// Shows the backup dialog.
  void _showBackupDialog() {
    LitRouteController(context).showDialogWidget(
      DiaryBackupDialog(
          installationID: widget.appSettings.installationID ?? ""),
    );
  }

  /// Navigates to the privacy policy screen.
  void _showPrivacyPolicy() {
    LitRouteController(context).pushCupertinoWidget(_PrivacyScreen());
  }

  /// Navigates to the licenses screen.
  void _showLicenses() {
    LitRouteController(context)
        .pushCupertinoWidget(ApplicationLicensesScreen());
  }

  /// Navigates to the credits screen.
  ///
  /// Extracts the photographer names from the local json file.
  void _showCredits() {
    LitRouteController(context).pushMaterialWidget(
      _CreditsScreen(),
    );
  }

  /// Show the app's onboarding screen.
  void _showOnboardingScreen() {
    LitRouteController(context).pushMaterialWidget(AppOnboardingScreen());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LitSettingsFooter(
      children: [
        LitPlainLabelButton(
          label: LeitmotifLocalizations.of(context).manageBackupLabel,
          onPressed: _showBackupDialog,
          textAlign: TextAlign.right,
        ),
        LitPlainLabelButton(
          label: LeitmotifLocalizations.of(context).startTourLabel,
          onPressed: _showOnboardingScreen,
          textAlign: TextAlign.right,
        ),
        LitPlainLabelButton(
          label: LeitmotifLocalizations.of(context).aboutAppLabel,
          onPressed: _showAboutThisAppDialog,
          textAlign: TextAlign.right,
        ),
        LitPlainLabelButton(
          label: LeitmotifLocalizations.of(context).privacyLabel,
          onPressed: _showPrivacyPolicy,
          textAlign: TextAlign.right,
        ),
        LitPlainLabelButton(
          label: LeitmotifLocalizations.of(context).creditsLabel,
          onPressed: _showCredits,
          textAlign: TextAlign.right,
        ),
        LitPlainLabelButton(
          label: LeitmotifLocalizations.of(context).licensesLabel,
          onPressed: _showLicenses,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

/// A customized [LitPrivacyPolicyScreen] widget displaying the app's
/// privacy policy.
class _PrivacyScreen extends StatelessWidget {
  /// Creates a [_PrivacyScreen].
  const _PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitPrivacyPolicyScreen(
      onAgreeCallback: () => LitRouteController(context).pop(),
      privacyBody: AppLocalizations.of(context).privacyDescr,
      art: HistoryOfMeLauncherIconArt(),
    );
  }
}

/// A customized [LitAboutDialog] widget displaying the app's about dialog.
class _AboutDialog extends StatelessWidget {
  /// Creates a [_AboutDialog].
  const _AboutDialog({Key? key}) : super(key: key);

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

/// A customized [LitCreditsScreen] widget displaying the app's about dialog.
class _CreditsScreen extends StatelessWidget {
  /// Creates a [_CreditsScreen].
  const _CreditsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitCreditsScreen(
      art: HistoryOfMeLauncherIconArt(
        boxShadow: LitBoxShadows.sm,
      ),
      appName: App.appName,
      appDescription: AppLocalizations.of(context).aboutAppDescr,
      credits: [
        CreditData(
          role: LeitmotifLocalizations.of(context).creatorLabel,
          names: [
            App.appDeveloper,
          ],
        ),
        CreditData(
          role: LeitmotifLocalizations.of(context).userExpericenceDesignLabel,
          names: [
            AppLocalizations.of(context).creatorName,
          ],
        ),
        CreditData(
          role: LeitmotifLocalizations.of(context).developmentLabel,
          names: [
            AppLocalizations.of(context).creatorName,
          ],
        ),
        CreditData(
          role: AppLocalizations.of(context).inspiredByLabel,
          names: [
            AppLocalizations.of(context).inspiredByMovieTitle,
          ],
        ),
      ],
    );
  }
}
