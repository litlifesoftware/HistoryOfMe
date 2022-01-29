import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/controller/routes/hom_navigator.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/styles.dart';
import 'package:history_of_me/view/shared/bookmark/bookmark_page_view.dart';
import 'package:leitmotif/leitmotif.dart';
import '../view/screens/DiaryScreen/diary_list_view.dart';

/// A screen widget displaying the user's diary on a vertical listview.
class DiaryScreen extends StatefulWidget {
  /// The bookmark's [AnimationController]
  final AnimationController bookmarkAnimation;

  /// Creates a [DiaryScreen].
  const DiaryScreen({
    Key? key,
    required this.bookmarkAnimation,
  }) : super(key: key);

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen>
    with TickerProviderStateMixin {
  late HOMNavigator _navigator;
  late AnimationController _listViewAnimation;
  late ScrollController _scrollController;

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
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _listViewAnimation = AnimationController(
      duration: LitAnimationDurations.appearAnimation,
      vsync: this,
    );
    _navigator = HOMNavigator(context);
    super.initState();
  }

  @override
  void dispose() {
    _listViewAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserDataProvider(
      builder: (context, userData) {
        return LitScaffold(
          actionButton: CollapseOnScrollActionButton(
            backgroundColor: Color(userData!.primaryColor),
            onPressed: _showCreateEntryDialog,
            scrollController: _scrollController,
            label:
                LeitmotifLocalizations.of(context).composeLabel.toUpperCase(),
            icon: LitIcons.plus,
            blurred: false,
          ),
          body: SafeArea(
            child: DiaryEntryProvider(
              builder: (context, diaryEntries) {
                return diaryEntries.isNotEmpty
                    ? DiaryListView(
                        animationController: _listViewAnimation,
                        bookmarkAnimation: widget.bookmarkAnimation,
                        diaryEntriesListSorted: diaryEntries
                          ..sort(
                            QueryController().sortEntriesByDateAscending,
                          ),
                        scrollController: _scrollController,
                        showFavoriteEntriesOnly: _showFavoriteEntriesOnly,
                        toggleShowFavoritesOnly: toggleShowFavoritesOnly,
                        userData: userData,
                      )
                    : _EmptyDiaryView(
                        animationController: widget.bookmarkAnimation,
                        handleCreateAction: _showCreateEntryDialog,
                        userData: userData,
                      );
              },
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
