import 'package:flutter/material.dart';
import 'package:history_of_me/controller/controllers.dart';
import 'package:history_of_me/styles.dart';
import 'package:history_of_me/view/screens/SelectBackupScreen/select_backup_screen.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:leitmotif/leitmotif.dart';

/// A Flutter `screen` widget allowing to restore an existing diary by reading
/// its backup file or to create a new diary (if restoring the diary is not
/// possible).
///
class RestoreDiaryScreen extends StatefulWidget {
  /// Handles the creation of a new diary.
  final void Function() onCreateNewInstance;

  /// Creates a [RestoreDiaryScreen].
  const RestoreDiaryScreen({
    Key? key,
    required this.onCreateNewInstance,
  }) : super(key: key);

  @override
  _RestoreDiaryScreenState createState() => _RestoreDiaryScreenState();
}

class _RestoreDiaryScreenState extends State<RestoreDiaryScreen> {
  late LitRouteController _routeController;
  late ScrollController _scrollController;

  /// Handles the `restore` action by navigating to the [SelectBackupScreen].
  void onRestoreBackup() {
    _routeController.pushCupertinoWidget(
      SelectBackupScreen(
        onCreateNewInstance: widget.onCreateNewInstance,
      ),
    );
  }

  @override
  void initState() {
    _routeController = LitRouteController(context);
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LitScaffold(
      appBar: FixedOnScrollTitledAppbar(
        scrollController: _scrollController,
        title: HOMLocalizations(context).newDiary,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LitGradients.greyGradient,
        ),
        child: ScrollableColumn(
          controller: _scrollController,
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          children: [
            LitScreenTitle(
              title: HOMLocalizations(context).newDiary,
              subtitle: HOMLocalizations(context).createNewDiary,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  CreateNewActionCard(
                    onCreate: widget.onCreateNewInstance,
                  ),
                  SizedBox(height: 24.0),
                  _RestoreBackupActionCard(
                    onRestore: onRestoreBackup,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _RestoreBackupActionCard extends StatelessWidget {
  final void Function() onRestore;

  const _RestoreBackupActionCard({
    Key? key,
    required this.onRestore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledActionCard(
      title: HOMLocalizations(context).restoreYourDiary,
      subtitle: HOMLocalizations(context).continueYourJourney,
      actionButtonData: [
        ActionButtonData(
          title: HOMLocalizations(context).restore,
          onPressed: onRestore,
          backgroundColor: AppColors.pastelGreen,
          accentColor: AppColors.pastelBlue,
        ),
      ],
    );
  }
}
