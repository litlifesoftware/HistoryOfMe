import 'package:flutter/material.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/controllers.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/models.dart';
import 'package:history_of_me/screens.dart';
import 'package:history_of_me/styles.dart';
import 'package:history_of_me/widgets.dart';
import 'package:leitmotif/leitmotif.dart';

/// A screen widget displaying the user's diary on a vertical listview.
class DiaryScreen extends StatefulWidget {
  /// The bookmark's [AnimationController]
  final AnimationController bookmarkAnimation;

  final AppSettings appSettings;

  /// Creates a [DiaryScreen].
  const DiaryScreen({
    Key? key,
    required this.bookmarkAnimation,
    required this.appSettings,
  }) : super(key: key);

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen>
    with TickerProviderStateMixin {
  late HOMNavigator _navigator;
  late AnimationController _listViewAniCon;
  late ScrollController _scrollController;
  bool _isTopOfNavStack = true;

  /// States whether to show only the favorite entries.
  bool _showFavoriteEntriesOnly = false;

  /// Shows the 'create entry' dialog.
  void _showCreateEntryDialog() {
    _navigator.showCreateEntryDialog();
  }

  /// Toggles the [_showFavoriteEntriesOnly] state value while replaying the
  /// animation controller to animate the list view tiles again.
  void toggleShowFavoritesOnly() {
    setState(() {
      _showFavoriteEntriesOnly = !_showFavoriteEntriesOnly;
    });
    if (_listViewAniCon.isCompleted) {
      _listViewAniCon.reverse().then((v) => _listViewAniCon.forward());
    }
  }

  /// Returns a diary entry list view or a information card if no entries
  /// have been created yet.
  Widget _buildListView(List<DiaryEntry> diaryEntries, UserData userData) {
    if (diaryEntries.isNotEmpty)
      return DiaryListView(
        animationController: _listViewAniCon,
        bookmarkAnimation: widget.bookmarkAnimation,
        diaryEntriesListSorted: diaryEntries
          ..sort(
            QueryController().sortEntriesByDateAscending,
          ),
        scrollController: _scrollController,
        showFavoriteEntriesOnly: _showFavoriteEntriesOnly,
        toggleShowFavoritesOnly: toggleShowFavoritesOnly,
        userData: userData,
      );
    return _EmptyDiaryView(
      animationController: widget.bookmarkAnimation,
      handleCreateAction: _showCreateEntryDialog,
      userData: userData,
    );
  }

  Color _generateActionButtonAccentColor(UserData userData) {
    return Color.lerp(Color(userData.primaryColor), Colors.white, 0.5) ??
        Colors.white;
  }

  /// Shows the `BackupOutdatedScreen` if required by checking the last backup
  /// timestamp provided by the [AppSettings] argument.
  void _showBackupOutdatedScreen() {
    // Abort if the `AppSettings` object is incomplete.
    if (widget.appSettings.lastBackup == null ||
        widget.appSettings.backupNoticeIgnored == null) return;

    // Abort if there hasn't been created a backup yet.
    if (widget.appSettings.lastBackup == DefaultData.lastBackup) return;

    DateTime last = DateTime.parse(widget.appSettings.lastBackup!);
    DateTime now = DateTime.now();
    int delayMs = 2500;
    bool isBackupOutdated =
        now.difference(last).inDays > DefaultData.maxDaysBackupOutdated;

    // Abort if backup is not outdated
    if (!isBackupOutdated) return;
    // Abort if notice is ignored
    if (widget.appSettings.backupNoticeIgnored!) return;
    // Abort if any screen other than the diary screen is on top of the stack
    if (!_isTopOfNavStack) return;

    Future.delayed(
      Duration(milliseconds: delayMs),
      () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BackupNoticeScreen(),
        ),
      ),
    );

    setState(() {
      _isTopOfNavStack = false;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _listViewAniCon = AnimationController(
      duration: Duration(milliseconds: 240),
      vsync: this,
    )..forward();
    _navigator = HOMNavigator(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _isTopOfNavStack = ModalRoute.of(context)?.isCurrent ?? false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _listViewAniCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the WidgetsBinding instance to call the BackupOutdatedScreen once
    // the first frame is rendered.
    WidgetsBinding.instance
        .addPostFrameCallback((ts) => _showBackupOutdatedScreen());
    return UserDataProvider(
      builder: (context, userData) {
        return LitScaffold(
          actionButton: CollapseOnScrollActionButton(
            backgroundColor: Colors.white,
            accentColor: _generateActionButtonAccentColor(userData!),
            onPressed: _showCreateEntryDialog,
            scrollController: _scrollController,
            label:
                LeitmotifLocalizations.of(context).composeLabel.toUpperCase(),
            icon: LitIcons.pencil,
            boxShadow: LitBoxShadows.md,
            blurred: false,
          ),
          body: SafeArea(
            child: DiaryEntryProvider(
              builder: (context, diaryEntries) => _buildListView(
                diaryEntries,
                userData,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The fallback content, initially displayed as long as no entries have been
/// created yet.
class _EmptyDiaryView extends StatelessWidget {
  final UserData userData;
  final AnimationController animationController;
  final void Function() handleCreateAction;
  const _EmptyDiaryView({
    Key? key,
    required this.userData,
    required this.animationController,
    required this.handleCreateAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: ScrollableColumn(
        children: [
          SizedBox(
            height: LitEdgeInsets.spacingTop.top,
          ),
          BookmarkPageView(
            animationController: animationController,
            userData: userData,
          ),
          _EmptyDiaryInfoCard(
            userData: userData,
            showCreateEntryDialog: handleCreateAction,
          ),
        ],
      ),
    );
  }
}

/// A card containing informations how to create the first diary entry.
class _EmptyDiaryInfoCard extends StatelessWidget {
  final UserData? userData;
  final void Function() showCreateEntryDialog;
  const _EmptyDiaryInfoCard({
    Key? key,
    required this.userData,
    required this.showCreateEntryDialog,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: LitEdgeInsets.card,
      child: LitTitledActionCard(
        title: AppLocalizations.of(context).createEntryLabel,
        subtitle: AppLocalizations.of(context).emptyDiarySubtitle,
        child: LitDescriptionTextBox(
          text: AppLocalizations.of(context).emptyDiaryBody,
        ),
        actionButtonData: [
          ActionButtonData(
            title: AppLocalizations.of(context).createEntryLabel,
            style: LitSansSerifStyles.button.copyWith(
              color: LitColors.white,
            ),
            accentColor: AppColors.purple,
            backgroundColor: AppColors.pink,
            onPressed: showCreateEntryDialog,
          ),
        ],
      ),
    );
  }
}
