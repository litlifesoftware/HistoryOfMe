part of widgets;

class HomeScreenDrawer extends StatelessWidget {
  final AppSettings appSettings;
  const HomeScreenDrawer({
    Key? key,
    required this.appSettings,
  }) : super(key: key);

  void _onTappedManageBackup(BuildContext context) {
    // Close the drawer
    Navigator.pop(context);
    //
    LitRouteController(context).showDialogWidget(
      DiaryBackupDialog(installationID: appSettings.installationID ?? ""),
    );
  }

  void _onTappedChangeName(BuildContext context, UserData? userData) {
    // Close the drawer
    Navigator.pop(context);
    //
    if (userData == null) return;
    LitRouteController(context).showDialogWidget(
      ChangeNameDialog(userData: userData),
    );
  }

  void _onTappedStartTour(BuildContext context) {
    // Close the drawer
    Navigator.pop(context);

    LitRouteController(context).pushMaterialWidget(AppOnboardingScreen());
  }

  void _onTappedCredits(BuildContext context) {
    // Close the drawer
    Navigator.pop(context);

    LitRouteController(context).pushMaterialWidget(
      AppCreditsScreen(),
    );
  }

  void _onTappedAboutApp(BuildContext context) {
    // Close the drawer
    Navigator.pop(context);

    LitRouteController(context).showDialogWidget(AppAboutDialog());
  }

  void _onTappedPrivacy(BuildContext context) {
    // Close the drawer
    Navigator.pop(context);

    LitRouteController(context).pushCupertinoWidget(AppPrivacyScreen());
  }

  void _onTappedLicenses(BuildContext context) {
    // Close the drawer
    Navigator.pop(context);

    LitRouteController(context).pushCupertinoWidget(
      ApplicationLicensesScreen(),
    );
  }

  /// Creates a [RelativeDateFormat].
  RelativeDateFormat createRelativeDateFormatter(BuildContext context) {
    return RelativeDateFormat(
      Localizations.localeOf(context),
    );
  }

  /// Returns a [RelativeDateTime] using the last backup timestamp.
  RelativeDateTime get _relativeDateTime {
    if (appSettings.lastBackup == null)
      throw Exception("AppSettings value corrupted.");

    return RelativeDateTime(
      dateTime: DateTime.now(),
      other: DateTime.parse(appSettings.lastBackup!),
    );
  }

  /// Creates a string using the [RelativeDateFormatter].
  String createRelativeDateTimeString(BuildContext context) {
    return createRelativeDateFormatter(context).format(_relativeDateTime);
  }

  String createLastBackupLabel(BuildContext context) {
    return appSettings.lastBackup != DefaultData.lastBackup
        ? (AppLocalizations.of(context).lastLabel +
            ": " +
            createRelativeDateTimeString(context))
        : AppLocalizations.of(context).noBackupCreatedLabel;
  }

  Widget buildBackupStatusIndicator() {
    if (appSettings.lastBackup == null) return SizedBox();

    if (appSettings.lastBackup == DefaultData.lastBackup) return SizedBox();

    DateTime last = DateTime.parse(appSettings.lastBackup!);
    DateTime now = DateTime.now();

    bool isBackupOutdated =
        now.difference(last).inDays > DefaultData.maxDaysBackupOutdated;

    return Transform(
      transform: Matrix4.translationValues(8.0, -4.0, 0),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: isBackupOutdated ? Color(0xFFF2E4E4) : Color(0xFFECFFE9),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              isBackupOutdated ? LitIcons.times : LitIcons.check,
              size: 12.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: LeitmotifLocalizations.of(context).settingsLabel,
      child: ListView(
        //padding: EdgeInsets.zero,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).manageYourDiaryLabel,
                    style: LitSansSerifStyles.subtitle2,
                  ),
                  Text(
                    LeitmotifLocalizations.of(context).settingsLabel,
                    style: LitSansSerifStyles.h4,
                  ),
                ],
              )),
          Divider(),
          ListTile(
            title: Text(
              LeitmotifLocalizations.of(context).manageBackupLabel,
              style: LitSansSerifStyles.button,
            ),
            leading: SizedBox(
              height: 36.0,
              width: 36.0,
              child: Stack(
                children: [
                  Icon(LitIcons.disk_alt, size: 36.0),
                  buildBackupStatusIndicator(),
                ],
              ),
            ),
            subtitle: Text(
              createLastBackupLabel(context),
              style: LitSansSerifStyles.caption,
            ),
            onTap: () => _onTappedManageBackup(context),
          ),
          UserDataProvider(
            builder: (contxt, userData) => _HomeScreenDrawerTile(
              title: AppLocalizations.of(context).changeNameLabel,
              icon: LitIcons.pencil,
              onTap: () => _onTappedChangeName(context, userData),
            ),
          ),
          _HomeScreenDrawerTile(
            title: LeitmotifLocalizations.of(context).startTourLabel,
            icon: LitIcons.info,
            onTap: () => _onTappedStartTour(context),
          ),
          _HomeScreenDrawerTile(
            title: LeitmotifLocalizations.of(context).creditsLabel,
            icon: LitIcons.person_solid,
            onTap: () => _onTappedCredits(context),
          ),
          _HomeScreenDrawerTile(
            title: LeitmotifLocalizations.of(context).aboutAppLabel,
            icon: LitIcons.llsw_smiley,
            onTap: () => _onTappedAboutApp(context),
          ),
          _HomeScreenDrawerTile(
            title: LeitmotifLocalizations.of(context).privacyLabel,
            icon: LitIcons.info,
            onTap: () => _onTappedPrivacy(context),
          ),
          _HomeScreenDrawerTile(
            title: LeitmotifLocalizations.of(context).licensesLabel,
            icon: LitIcons.document_alt,
            onTap: () => _onTappedLicenses(context),
          ),
        ],
      ),
    );
  }
}

class _HomeScreenDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onTap;

  const _HomeScreenDrawerTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: LitSansSerifStyles.button,
      ),
      leading: Icon(icon),
      onTap: onTap,
    );
  }
}
