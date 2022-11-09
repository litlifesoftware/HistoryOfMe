import 'package:flutter/material.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/model/app_settings.dart';
import 'package:history_of_me/widgets.dart';
import 'package:leitmotif/leitmotif.dart';

/// A `screen` widget notifying the user to create an updated backup.
///
/// - Accesses the [DiaryBackupDialog] to create the updated backup.
/// - Provides the option to exit the screen without if the user has no
/// intention to create an updated backup.
class BackupNoticeScreen extends StatefulWidget {
  const BackupNoticeScreen({Key? key}) : super(key: key);

  @override
  State<BackupNoticeScreen> createState() => _BackupNoticeScreenState();
}

class _BackupNoticeScreenState extends State<BackupNoticeScreen> {
  late ScrollController _scrollController;
  late AppAPI _api;

  /// Handles the `will pop` action by setting the `backupNoticeIgnored` flag
  /// to true.
  ///
  /// Pops the screen from the navigation stack.
  Future<bool> _onWillPop(AppSettings appSettings) {
    _api.updateBackupNoticeIgnored(appSettings, true);

    return Future<bool>(() => true);
  }

  /// Shows the [DiaryBackupDialog].
  ///
  /// The option to allow the deletion of the backup is disabled.
  void _showBackupDialog(AppSettings appSettings) {
    LitRouteController(context).showDialogWidget(
      DiaryBackupDialog(
        installationID: appSettings.installationID ?? "",
        closeOnFinish: true,
        allowDelete: false,
      ),
    );
  }

  void _dismissNotice(AppSettings appSettings) {
    _api.updateBackupNoticeIgnored(appSettings, true);
    Navigator.of(context).pop();
  }

  void _returnToHomeScreen() {
    Navigator.of(context).pop();
  }

  int _calcDaysSinceLastBackup(AppSettings appSettings) {
    return DateTime.now()
        .difference(DateTime.parse(appSettings.lastBackup!))
        .inDays;
  }

  bool _isBackupOutdated(AppSettings appSettings) =>
      _calcDaysSinceLastBackup(appSettings) > DefaultData.maxDaysBackupOutdated;

  @override
  void initState() {
    _scrollController = ScrollController();
    _api = AppAPI();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsProvider(
      builder: (context, appSettings) => WillPopScope(
        onWillPop: () => _onWillPop(appSettings),
        child: (_isBackupOutdated(appSettings))
            ? _BackupOutdatedContent(
                appSettings: appSettings,
                dismissNotice: _dismissNotice,
                scrollController: _scrollController,
                showBackupDialog: _showBackupDialog,
              )
            : _BackupUpToDateContent(
                returnToHomeScreen: _returnToHomeScreen,
              ),
      ),
    );
  }
}

class _BackupOutdatedContent extends StatelessWidget {
  final AppSettings appSettings;
  final ScrollController scrollController;

  final void Function(AppSettings appSettings) showBackupDialog;
  final void Function(AppSettings appSettings) dismissNotice;

  const _BackupOutdatedContent({
    Key? key,
    required this.appSettings,
    required this.scrollController,
    required this.showBackupDialog,
    required this.dismissNotice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitScaffold(
      appBar: FixedOnScrollTitledAppbar(
        scrollController: scrollController,
        title: AppLocalizations.of(context).backupOutdatedLabel,
      ),
      actionButton: CollapseOnScrollActionButton(
        scrollController: scrollController,
        icon: LitIcons.disk,
        accentColor: Colors.white,
        backgroundColor: Colors.white,
        label: AppLocalizations.of(context).backupNowLabel.toUpperCase(),
        boxShadow: LitBoxShadows.md,
        blurred: false,
        onPressed: () => showBackupDialog(appSettings),
      ),
      body: Padding(
        padding: LitEdgeInsets.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LitScreenTitle(
              title: AppLocalizations.of(context).backupYourDiaryLabel,
              subtitle: AppLocalizations.of(context).backupOutdatedLabel,
            ),
            SizedBox(height: 16.0),
            LitDescriptionTextBox(
              icon: Icons.warning,
              text: AppLocalizations.of(context).backupOutdatedDescr,
            ),
            SizedBox(height: 16.0),
            LitTitledActionCard(
              title: AppLocalizations.of(context).updateBackupLabel,
              subtitle: AppLocalizations.of(context).createUpdatedBackupLabel,
              actionButtonData: [
                ActionButtonData(
                  title: AppLocalizations.of(context).backupNowLabel,
                  backgroundColor: LitColors.green100,
                  accentColor: LitColors.green100,
                  onPressed: () => showBackupDialog(appSettings),
                )
              ],
            ),
            SizedBox(height: 16.0),
            LitTitledActionCard(
              title: AppLocalizations.of(context).maybeLaterLabel,
              subtitle: AppLocalizations.of(context).continueWithoutBackupLabel,
              actionButtonData: [
                ActionButtonData(
                  title: LeitmotifLocalizations.of(context).dismissLabel,
                  onPressed: () => dismissNotice(appSettings),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _BackupUpToDateContent extends StatelessWidget {
  final void Function() returnToHomeScreen;
  const _BackupUpToDateContent({
    Key? key,
    required this.returnToHomeScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitScaffold(
      body: Padding(
        padding: LitEdgeInsets.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LitScreenTitle(
              title: AppLocalizations.of(context).backupYourDiaryLabel,
              subtitle: AppLocalizations.of(context).backupOutdatedLabel,
            ),
            SizedBox(height: 16.0),
            LitDescriptionTextBox(
              icon: LitIcons.check,
              text: AppLocalizations.of(context).upToDateDescr,
            ),
            SizedBox(height: 16.0),
            LitTitledActionCard(
              title: AppLocalizations.of(context).goBackLabel,
              subtitle: AppLocalizations.of(context).returnToHomescreenLabel,
              actionButtonData: [
                ActionButtonData(
                  title: AppLocalizations.of(context).returnLabel,
                  backgroundColor: LitColors.green100,
                  accentColor: LitColors.green100,
                  onPressed: returnToHomeScreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
